load("//build:icerules.bzl", "verilog_library", "ice_binary")

verilog_library(
    name = "hvsync_generator_lib",
    srcs = [ "hvsync_generator.v" ])

verilog_library(
    name = "digits16_array_lib",
    srcs = [ "digits16_array.v" ],
    data = [ "digits5x5.txt" ])

ice_binary(
    name = "test_digits",
    src = "test_digits.v",
    pcf = "test_digits.pcf",
    out = "test_digits.bin",
    deps = [
        ":digits16_array_lib",
        ":hvsync_generator_lib",
    ])

ice_binary(
    name = "test_hvsync",
    src = "test_hvsync.v",
    pcf = "test_hvsync.pcf",
    out = "test_hvsync.bin",
    deps = [ ":hvsync_generator_lib" ])
