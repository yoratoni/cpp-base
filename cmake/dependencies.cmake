# Including fetch content module for external dependencies
include(FetchContent)

# Auto find packages (vcpkg), add the port to "vcpkg.json" first, e.g.:
# find_package(fmt CONFIG REQUIRED)

# Fetching Catch2 from source so it compiles with the project's own compiler,
# avoiding MSVC/clang ABI mismatches that arise when linking against
# vcpkg-prebuilt binaries
FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        v3.5.4
    GIT_SHALLOW    TRUE
)
FetchContent_MakeAvailable(Catch2)
list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
include(Catch)

# Suppress warnings from Catch2's internal headers by marking them as system includes,
# without this, Catch2's template machinery (e.g. "BinaryExpr") emits "-Wnon-virtual-dtor"
# and similar warnings that pollute test build output
set_target_properties(Catch2 Catch2WithMain PROPERTIES
    INTERFACE_SYSTEM_INCLUDE_DIRECTORIES
    "$<TARGET_PROPERTY:Catch2,INTERFACE_INCLUDE_DIRECTORIES>"
)
