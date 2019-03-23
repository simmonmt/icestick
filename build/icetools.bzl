_ICETOOLS = '/Users/simmonmt/icetools/usr/local'
_ICEBIN = _ICETOOLS + '/bin'
_ICEPACK = _ICEBIN + '/icepack'
_PNR = _ICEBIN + '/arachne-pnr'
_YOSYS = _ICEBIN + '/yosys'

def _stripext(s):
    return s.rpartition(".")[0]

def _subext(s, newext):
    return _stripext(s) + "." + newext

def yosys(name, src, blif, incdir=None):
    cmds = []
    
    if incdir:
        cmds.append("verilog_defaults -add -I%s" % incdir)
    cmds.append("synth_ice40 -blif $@")
    
    native.genrule(
        name = name,
        srcs = [src],
        outs = [blif],
        cmd = _YOSYS + " -p '%s' $(location %s)" % (';'.join(cmds), src))

def placenroute(name, blif, pcf, out):
    native.genrule(
        name = name,
        srcs = [blif, pcf],
        outs = [out],
        cmd = _PNR + " -d 1k -p $(location %s) $(location %s) -o $@" % (pcf, blif))

def icepack(name, src, out, output_to_bindir=False):
    native.genrule(
        name = name,
        srcs = [src],
        outs = [out],
        cmd = _ICEPACK + " $(location %s) > $@" % src,
        output_to_bindir = output_to_bindir)

def ice_binary(name, src, pcf, out, incdir=None, visibility=None):
    blif = _subext(src, "blif")
    yosys(name = name + "_yosys",
          src = src,
          blif = blif,
          incdir = incdir)

    asc = _subext(src, "asc")
    placenroute(name = name + "_pnr",
                blif = blif,
                pcf = pcf,
                out = asc)

    bin = _subext(src, "bin")
    icepack(name = name + "_pack",
            src = asc,
            out = bin,
            output_to_bindir = True)

    
                
    
