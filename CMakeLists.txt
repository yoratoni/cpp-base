cmake_minimum_required(VERSION 3.21)

project(CppBase VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Emit build/compile_commands.json, which is what clangd reads to resolve includes and flags
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enable LTO/IPO for "Release" builds so the optimizer can inline across translation
# unit boundaries, translates to "/GL /LTCG" on MSVC and "-flto" on Clang/GCC,
# scoped per-target (not global) so it doesn't propagate to dependencies
# whose toolchain may not advertise IPO flags for every language
cmake_policy(SET CMP0069 NEW)
include(CheckIPOSupported)
check_ipo_supported(RESULT _ipo_ok OUTPUT _ipo_err LANGUAGES CXX)
if(NOT _ipo_ok)
    message(WARNING "IPO/LTO not supported by toolchain: ${_ipo_err}")
endif()

# Compiler flags and target helpers
include(cmake/compilerFlags.cmake)
include(cmake/runtimeDlls.cmake)

# Dependencies
include(cmake/dependencies.cmake)

# Core library (all sources except main.cpp, shared by the executable and tests)
# Note: Uses "CONFIGURE_DEPENDS" to automatically re-run CMake when new files are added
file(GLOB_RECURSE LIB_SOURCES CONFIGURE_DEPENDS src/*.cpp)
list(FILTER LIB_SOURCES EXCLUDE REGEX ".*/main\.cpp$")

# Create the library and apply compiler flags
add_library(CppBaseLib STATIC ${LIB_SOURCES})
apply_compiler_flags(CppBaseLib)
if(_ipo_ok)
    set_target_properties(CppBaseLib PROPERTIES INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
endif()

# Include directories
target_include_directories(CppBaseLib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Link libraries (vcpkg / FetchContent targets from "cmake/dependencies.cmake")
target_link_libraries(CppBaseLib PUBLIC)

# Executable
add_executable(CppBase src/main.cpp)
apply_compiler_flags(CppBase)
target_link_libraries(CppBase PRIVATE CppBaseLib)
if(_ipo_ok)
    set_target_properties(CppBase PROPERTIES INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
endif()

# On Windows, copy all required runtime DLLs next to the executable after each build
copy_runtime_dlls(CppBase)

# Install into bin sub-directory of the selected location
install(TARGETS CppBase DESTINATION bin)

# On Windows, install runtime DLLs alongside the executable
if(WIN32)
    install(FILES $<TARGET_RUNTIME_DLLS:CppBase> DESTINATION bin)
endif()

# Tests
enable_testing()

# Test sources
file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS tests/*.cpp)

# Create the test executable and apply compiler flags
add_executable(CppBaseTests ${TEST_SOURCES})
apply_compiler_flags(CppBaseTests)
if(_ipo_ok)
    set_target_properties(CppBaseTests PROPERTIES INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
endif()

# Link libraries
target_link_libraries(CppBaseTests PRIVATE CppBaseLib Catch2::Catch2WithMain)

# Must happen before "catch_discover_tests" so DLLs are present when the exe is run at build time
copy_runtime_dlls(CppBaseTests)

# Discover tests
catch_discover_tests(CppBaseTests)
