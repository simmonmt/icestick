load("//build:icerules.bzl", "ice_binary", "ice_library", "ice_test")

ice_library(
    name = "testutil",
    testonly = 1,
    srcs = ["testutil.v"],
)

ice_library(
    name = "startup_lib",
    srcs = ["startup.v"],
)

ice_test(
    name = "startup_test",
    size = "small",
    src = "startup_test.v",
    deps = [
        ":startup_lib",
        ":testutil",
    ],
)

ice_library(
    name = "hvsync_generator_lib",
    srcs = ["hvsync_generator.v"],
)

ice_library(
    name = "digits16_array_lib",
    srcs = ["digits16_array.v"],
    data = ["digits5x5.txt"],
)

ice_binary(
    name = "test_digits",
    src = "test_digits.v",
    out = "test_digits.bin",
    pcf = "test_digits.pcf",
    deps = [
        ":digits16_array_lib",
        ":hvsync_generator_lib",
    ],
)

ice_binary(
    name = "test_hvsync",
    src = "test_hvsync.v",
    out = "test_hvsync.bin",
    pcf = "test_hvsync.pcf",
    deps = [":hvsync_generator_lib"],
)

ice_library(
    name = "abs_pong_logic",
    srcs = ["abs_pong_logic.v"],
)

ice_binary(
    name = "abs_pong",
    src = "abs_pong.v",
    out = "abs_pong.bin",
    pcf = "icestick.pcf",
    deps = [
        ":abs_pong_logic",
        ":hvsync_generator_lib",
        ":startup_lib",
    ],
)

ice_test(
    name = "abs_pong_logic_test",
    size = "small",
    src = "abs_pong_logic_test.v",
    deps = [
        ":abs_pong_logic",
        ":testutil",
    ],
)
