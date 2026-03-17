cmake_minimum_required(VERSION 3.20)

project(CppBase VERSION 0.0.1 LANGUAGES CXX)

# Standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Compiler flags
include(cmake/compilerFlags.cmake)

# Dependencies
#find_package(fmt CONFIG REQUIRED)

# Root directory for source files
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

# Executable
# Note: Uses "CONFIGURE_DEPENDS" to automatically re-run CMake when new source files are added
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/**/*.cpp src/*.cpp)
add_executable(CppBase ${SOURCES})

# Included headers
#target_include_directories(worker PRIVATE include)

# Apply the compiler flags
apply_compiler_flags(CppBase)

# Dependencies (defined in deps CMake files)
target_link_libraries(CppBase PRIVATE
    #fmt::fmt
)

# Install into bin directory
install(TARGETS CppBase DESTINATION bin)
