load("@bazel_skylib//lib:paths.bzl", "paths")

VerilogFiles = provider("transitive_sources")

def _get_transitive_srcs(srcs, deps):
    """Obtain the source files for a target and its transitive dependencies.
    Args:
      srcs: a list of source files
      deps: a list of targets that are direct dependencies
    Returns:
      a collection of the transitive sources
    """
   
    return depset(
        srcs,
        transitive = [dep[VerilogFiles].transitive_sources for dep in deps],
    )

def _run_iverilog(actions, iverilog_path, src, vvp, trans_srcs):
    args = actions.args()
    args.add_all(['-o', vvp.path])
    args.add(src.path)

    actions.run(
        inputs=trans_srcs,
        outputs=[vvp],
        arguments=[args],
        mnemonic='iVerilog',
        executable=iverilog_path)

def _run_yosys(actions, yosys_path, src, blif, yosys_log, trans_srcs):
    args = actions.args()
    args.add_all(['-p', 'synth_ice40 -blif {}'.format(blif.path)])
    args.add('-q')  # Only log warnings and errors to console
    args.add_all(['-l', yosys_log.path])
    args.add(src)

    actions.run(
        inputs=trans_srcs,
        outputs=[blif, yosys_log],
        arguments=[args],
        mnemonic='YoSys',
        executable=yosys_path)

def _run_pnr(actions, pnr_path, blif, pcf, asc):
    args = actions.args()
    args.add_all(['-d', '1k'])
    args.add_all(['-p', pcf])
    args.add_all(['-o', asc])
    args.add('-q')  # Dont output progress messages
    args.add(blif.path)

    actions.run(
        inputs=[blif, pcf],
        outputs=[asc],
        arguments=[args],
        mnemonic='ArachnePnR',
        executable=pnr_path)

def _run_icepack(actions, icepack_path, asc, bin):
    args = actions.args()
    args.add(asc.path)
    args.add(bin.path)

    actions.run(
        inputs=[asc],
        outputs=[bin],
        arguments=[args],
        mnemonic='IcePack',
        executable=icepack_path)

def _run_iverilog_for_srcs(actions, iverilog_path, srcs, deps):
    trans_srcs = _get_transitive_srcs(srcs, deps)

    vvps = []
    for src in srcs:
        vvp = actions.declare_file(
            paths.basename(paths.replace_extension(src.path, '.vvp')))
        vvps.append(vvp)

        _run_iverilog(actions, iverilog_path, src, vvp, trans_srcs)

    return vvps

def _verilog_library_impl(ctx):
    tc = ctx.toolchains["//build/toolchains:toolchain_type"]

    vvps = _run_iverilog_for_srcs(ctx.actions, tc.iverilog_path, ctx.files.srcs,
                                  ctx.attr.deps)

    trans_srcs = _get_transitive_srcs(ctx.files.srcs + vvps, ctx.attr.deps)
    
    return [
        VerilogFiles(transitive_sources = trans_srcs),
        DefaultInfo(files = trans_srcs),
    ]

verilog_library = rule(
    implementation = _verilog_library_impl,
    attrs = {
        'srcs': attr.label_list(allow_files=True, mandatory=True),
        'deps': attr.label_list(providers=[VerilogFiles]),
    },
    toolchains = ["//build/toolchains:toolchain_type"],
)

def _declare_file(ctx, path, new_ext):
    return ctx.actions.declare_file(
        paths.basename(paths.replace_extension(path, new_ext)))

def _ice_binary_impl(ctx):
    tc = ctx.toolchains["//build/toolchains:toolchain_type"]

    vvps = _run_iverilog_for_srcs(ctx.actions, tc.iverilog_path, ctx.files.src,
                                  ctx.attr.deps)

    trans_srcs = _get_transitive_srcs(ctx.files.src + vvps, ctx.attr.deps).to_list()

    blif = _declare_file(ctx, ctx.outputs.out.path, '.blif')
    yosys_log = _declare_file(ctx, ctx.outputs.out.path, '.yosys_log')
    _run_yosys(ctx.actions, tc.yosys_path, ctx.files.src, blif, yosys_log, trans_srcs)

    asc = ctx.actions.declare_file(
        paths.basename(paths.replace_extension(ctx.outputs.out.path, '.asc')))
    _run_pnr(ctx.actions, tc.arachne_pnr_path, blif, ctx.files.pcf[0], asc)

    _run_icepack(ctx.actions, tc.icepack_path, asc, ctx.outputs.out)

ice_binary = rule(
    implementation = _ice_binary_impl,
    attrs = {
        'src': attr.label(allow_single_file=True, mandatory=True),
        'pcf': attr.label(allow_single_file=True, mandatory=True),
        'out': attr.output(mandatory=True),
        'deps': attr.label_list(providers=[VerilogFiles]),
    },
    toolchains = ["//build/toolchains:toolchain_type"],
)
        
