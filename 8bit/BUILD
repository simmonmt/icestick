load("//build:icerules.bzl", "verilog_library", "ice_binary")

verilog_library(
    name = "hvsync_generator_lib",
    srcs = [ "hvsync_generator.v" ])

ice_binary(
    name = "test_hvsync",
    src = "test_hvsync.v",
    pcf = "test_hvsync.pcf",
    out = "test_hvsync.bin",
    deps = [ ":hvsync_generator_lib" ])
