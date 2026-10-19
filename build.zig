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

    const tglfw = b.dependency("glfw_zig", .{
        .target = target,
        .optimize = optimize,
    });

    // AllYourCodeBase's GLFW
    const aglfw = b.dependency("glfw", .{
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

    const alib = b.addLibrary(.{
        .name = "test-aycb-glfw",
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

    const aexe = b.addExecutable(.{
        .name = "TestApp-aycb-glfw",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
        }),
    });

    for ([_]*std.Build.Step.Compile{ tlib, alib }) |lib| {
        lib.root_module.addCSourceFiles(.{
            .files = lib_sources,
            .flags = cxx_flags
        });
        b.installArtifact(lib);
    }

    const tglfw_lib = tglfw.artifact("glfw");
    tlib.root_module.linkLibrary(tglfw_lib);
    tlib.root_module.addIncludePath(tglfw.path("include"));
    tlib.root_module.addIncludePath(b.path("vendors/glad"));

    const aglfw_lib = aglfw.artifact("glfw");
    alib.root_module.linkLibrary(aglfw_lib);
    alib.root_module.addIncludePath(aglfw.path("include"));
    alib.root_module.addIncludePath(b.path("vendors/glad"));

    texe.root_module.addCSourceFiles(.{
        .files = cxx_sources,
        .flags = cxx_flags
    });

    texe.root_module.linkLibrary(tlib);

    texe.root_module.addIncludePath(b.path("vendors/glad"));
    texe.root_module.addIncludePath(b.path("vendors/glfw"));
    texe.root_module.addIncludePath(b.path("include"));
    b.installArtifact(texe);

    aexe.root_module.addCSourceFiles(.{
        .files = cxx_sources,
        .flags = cxx_flags
    });

    aexe.root_module.linkLibrary(alib);

    aexe.root_module.addIncludePath(b.path("vendors/glad"));
    aexe.root_module.addIncludePath(b.path("vendors/glfw"));
    aexe.root_module.addIncludePath(b.path("include"));
    b.installArtifact(aexe);
}
