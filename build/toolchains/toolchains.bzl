def _icetools_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(
        arachne_pnr_path = ctx.attr.arachne_pnr_path,
        icepack_path = ctx.attr.icepack_path,
        iverilog_path = ctx.attr.iverilog_path,
        yosys_path = ctx.attr.yosys_path,
    )]
        
icetools_toolchain = rule(
    implementation = _icetools_toolchain_impl,
    attrs = {
        'arachne_pnr_path': attr.string(mandatory=True),
        'icepack_path': attr.string(mandatory=True),
        'iverilog_path': attr.string(mandatory=True),
        'yosys_path': attr.string(mandatory=True),
    },
    provides=[platform_common.ToolchainInfo],
)

