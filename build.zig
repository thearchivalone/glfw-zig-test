const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cxx_flags = &[_][]const u8{
        "-std=c++23",
    };

    const lib_sources = &[_][]const u8{
        "vendors/glad/glad.cpp",
    };

    const cxx_sources = &[_][]const u8{
        "src/main.cpp",
    };

    // This particular version of glfw builds Wayland, Vulkan and X11 sources
    const tglfw = b.dependency("glfw_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const tlib = b.addLibrary(.{
        .name = "test-tiawl-glfw",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });

    const texe = b.addExecutable(.{
        .name = "TestApp-tiawl-glfw",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });

    tlib.root_module.addIncludePath(b.path("include"));

    tlib.root_module.addCSourceFiles(.{
        .files = lib_sources,
        .flags = cxx_flags
    });
    b.installArtifact(tlib);

    const tglfw_lib = tglfw.artifact("glfw");
    tlib.root_module.linkLibrary(tglfw_lib);
    tlib.root_module.addIncludePath(tglfw.path("include"));
    tlib.root_module.addIncludePath(b.path("vendors/glad"));

    texe.root_module.addCSourceFiles(.{
        .files = cxx_sources,
        .flags = cxx_flags
    });

    texe.root_module.linkLibrary(tlib);

    texe.root_module.addIncludePath(b.path("vendors/glad"));
    texe.root_module.addIncludePath(b.path("vendors/glfw"));
    texe.root_module.addIncludePath(b.path("include"));
    b.installArtifact(texe);
}
