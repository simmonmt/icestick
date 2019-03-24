load("//build:icerules.bzl", "ice_binary", "ice_library", "ice_test")

ice_library(
    name = "testutil",
    testonly = 1,
    srcs = [ "testutil.v"])

ice_library(
    name = "startup_lib",
    srcs = [ "startup.v" ])

ice_test(
    name = "startup_test",
    src = "startup_test.v",
    size = "small",
    deps = [
        ":startup_lib",
        ":testutil",
    ])

ice_library(
    name = "hvsync_generator_lib",
    srcs = [ "hvsync_generator.v" ])

ice_library(
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

ice_library(
    name = "abs_pong_logic",
    srcs = [ "abs_pong_logic.v" ])

ice_binary(
    name = "abs_pong",
    src = "abs_pong.v",
    pcf = "icestick.pcf",
    out = "abs_pong.bin",
    deps = [
        ":abs_pong_logic",
        ":hvsync_generator_lib",
        ":startup_lib",
    ])

ice_test(
    name = "abs_pong_logic_test",
    src = "abs_pong_logic_test.v",
    size = "small",
    deps = [
        ":abs_pong_logic",
        ":testutil",
    ])
    
