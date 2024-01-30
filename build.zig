const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config_h = b.addConfigHeader(.{
        .style = .blank,
        .include_path = "config.h",
    }, .{
        .HAVE_ERROR_H = true,
        .HAVE_DECL_RAWMEMCHR = true,
        .HAVE_DECL_MEMRCHR = true,
        .HAVE_MREMAP = true,
        .HAVE_DECL_POWEROF2 = true,
        .HAVE_DECL_MEMPCPY = true,
        .HAVE_DECL_REALLOCARRAY = true,
        .internal_function = null,
        .attribute_hidden = null,
    });
    const lib = b.addStaticLibrary(.{
        .name = "libelf",
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.link_libc = true;
    lib.defineCMacro("HAVE_CONFIG_H", "");
    lib.addConfigHeader(config_h);
    lib.addCSourceFiles(.{
        .files = &elf_src,
        .flags = &.{},
    });
    lib.addIncludePath(.{ .path = "include" });
    lib.installHeadersDirectoryOptions(.{
        .source_dir = .{ .path = "include" },
        .install_dir = .header,
        .install_subdir = "elf",
        .include_extensions = &elf_headers,
    });
    lib.installConfigHeader(config_h, .{});
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "libelf",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
    const lib_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}

const elf_headers = [_][]const u8{
    "libelf.h",
    "gelf.h",
    "nlist.h",
};

const elf_src = [_][]const u8{
    "src/elf32_checksum.c",
    "src/elf32_fsize.c",
    "src/elf32_getchdr.c",
    "src/elf32_getehdr.c",
    "src/elf32_getphdr.c",
    "src/elf32_getshdr.c",
    "src/elf32_newehdr.c",
    "src/elf32_newphdr.c",
    "src/elf32_offscn.c",
    "src/elf32_updatefile.c",
    "src/elf32_updatenull.c",
    "src/elf32_xlatetof.c",
    "src/elf32_xlatetom.c",
    "src/elf64_checksum.c",
    "src/elf64_fsize.c",
    "src/elf64_getchdr.c",
    "src/elf64_getehdr.c",
    "src/elf64_getphdr.c",
    "src/elf64_getshdr.c",
    "src/elf64_newehdr.c",
    "src/elf64_newphdr.c",
    "src/elf64_offscn.c",
    "src/elf64_updatefile.c",
    "src/elf64_updatenull.c",
    "src/elf64_xlatetof.c",
    "src/elf64_xlatetom.c",
    "src/elf_begin.c",
    "src/elf_clone.c",
    "src/elf_cntl.c",
    "src/elf_end.c",
    "src/elf_error.c",
    "src/elf_fill.c",
    "src/elf_flagdata.c",
    "src/elf_flagehdr.c",
    "src/elf_flagelf.c",
    "src/elf_flagphdr.c",
    "src/elf_flagscn.c",
    "src/elf_flagshdr.c",
    "src/elf_getarhdr.c",
    "src/elf_getaroff.c",
    "src/elf_getarsym.c",
    "src/elf_getbase.c",
    "src/elf_getdata.c",
    "src/elf_getdata_rawchunk.c",
    "src/elf_getident.c",
    "src/elf_getphdrnum.c",
    "src/elf_getscn.c",
    "src/elf_getshdrnum.c",
    "src/elf_getshdrstrndx.c",
    "src/elf_gnu_hash.c",
    "src/elf_hash.c",
    "src/elf_kind.c",
    "src/elf_memory.c",
    "src/elf_ndxscn.c",
    "src/elf_newdata.c",
    "src/elf_newscn.c",
    "src/elf_next.c",
    "src/elf_nextscn.c",
    "src/elf_rand.c",
    "src/elf_rawdata.c",
    "src/elf_rawfile.c",
    "src/elf_readall.c",
    "src/elf_scnshndx.c",
    "src/elf_strptr.c",
    "src/elf_update.c",
    "src/elf_version.c",
    "src/gelf_checksum.c",
    "src/gelf_fsize.c",
    "src/gelf_getauxv.c",
    "src/gelf_getchdr.c",
    "src/gelf_getclass.c",
    "src/gelf_getdyn.c",
    "src/gelf_getehdr.c",
    "src/gelf_getlib.c",
    "src/gelf_getmove.c",
    "src/gelf_getnote.c",
    "src/gelf_getphdr.c",
    "src/gelf_getrela.c",
    "src/gelf_getrel.c",
    "src/gelf_getshdr.c",
    "src/gelf_getsym.c",
    "src/gelf_getsyminfo.c",
    "src/gelf_getsymshndx.c",
    "src/gelf_getverdaux.c",
    "src/gelf_getverdef.c",
    "src/gelf_getvernaux.c",
    "src/gelf_getverneed.c",
    "src/gelf_getversym.c",
    "src/gelf_newehdr.c",
    "src/gelf_newphdr.c",
    "src/gelf_offscn.c",
    "src/gelf_update_auxv.c",
    "src/gelf_update_dyn.c",
    "src/gelf_update_ehdr.c",
    "src/gelf_update_lib.c",
    "src/gelf_update_move.c",
    "src/gelf_update_phdr.c",
    "src/gelf_update_rela.c",
    "src/gelf_update_rel.c",
    "src/gelf_update_shdr.c",
    "src/gelf_update_sym.c",
    "src/gelf_update_syminfo.c",
    "src/gelf_update_symshndx.c",
    "src/gelf_update_verdaux.c",
    "src/gelf_update_verdef.c",
    "src/gelf_update_vernaux.c",
    "src/gelf_update_verneed.c",
    "src/gelf_update_versym.c",
    "src/gelf_xlate.c",
    "src/gelf_xlatetof.c",
    "src/gelf_xlatetom.c",
    "src/libelf_crc32.c",
    "src/libelf_next_prime.c",
    "src/nlist.c",
};
