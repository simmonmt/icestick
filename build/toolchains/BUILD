load("@bazel_skylib//lib:paths.bzl", "paths")
load("//build/toolchains:toolchains.bzl", "icetools_toolchain")

package(
    default_visibility = ["//visibility:public"],
)

toolchain_type(name = "toolchain_type")

_SIMMONMT_ROOT = "/Users/simmonmt/icetools/usr/local/bin"

icetools_toolchain(
    name = "icetools_simmonmt",
    arachne_pnr_path = paths.join(_SIMMONMT_ROOT, "arachne-pnr"),
    icepack_path = paths.join(_SIMMONMT_ROOT, "icepack"),
    iverilog_path = paths.join(_SIMMONMT_ROOT, "iverilog"),
    vvp_path = paths.join(_SIMMONMT_ROOT, "vvp"),
    yosys_path = paths.join(_SIMMONMT_ROOT, "yosys"),
)

toolchain(
    name = "icetools_simmonmt_toolchain",
    toolchain = ":icetools_simmonmt",
    toolchain_type = ":toolchain_type",
)
