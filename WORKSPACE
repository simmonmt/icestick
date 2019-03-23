load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

register_toolchains(
    "//build/toolchains:icetools_simmonmt_toolchain",
)

git_repository(
    name = "bazel_skylib",
    remote = "https://github.com/bazelbuild/bazel-skylib.git",
    tag = "0.8.0",
)
