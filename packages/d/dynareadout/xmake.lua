package("dynareadout")

    set_homepage("https://github.com/PucklaMotzer09/dynareadout")
    set_description("Ansi C library for parsing binary output files of LS Dyna (d3plot, binout)")

    add_urls("https://github.com/PucklaMotzer09/dynareadout/archive/refs/tags/$(version).tar.gz",
             "https://github.com/PucklaMotzer09/dynareadout.git")
    add_versions("0.1", "833c8516c77ab57c56e942692e1fea2c96c50b7adfebd7f6f633ed43aaf46a56")
    add_versions("0.2", "47c147f1af092b8f2aad1b883d92e6fa76f0096b911b0d4cca2ed675d4f445bd")

    add_configs("cpp", {description = "Build the C++ bindings", default = true, type = "boolean"})

    on_install("windows", "linux", "macosx", "mingw", function (package)
        local configs = {}
        configs.build_test = "n"
        configs.build_cpp = package:config("cpp") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("binout_open", {includes = "binout.h", configs = {languages = "ansi"}}))
        assert(package:has_cfuncs("d3plot_open", {includes = "d3plot.h", configs = {languages = "ansi"}}))
        if package:config("cpp") then
            assert(package:has_cxxtypes("dro::Binout", {includes = "binout.hpp", configs = {languages = "cxx17"}}))
            assert(package:has_cxxtypes("dro::D3plot", {includes = "d3plot.hpp", configs = {languages = "cxx17"}}))
            assert(package:has_cxxtypes("dro::Array<int32_t>",  {includes = {"array.hpp", "cstdint"}, configs = {languages = "cxx17"}}))
        end
    end)
