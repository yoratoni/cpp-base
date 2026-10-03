<p align="center">
  <br />
  <a href="https://www.yoratoni.com" target="_blank"><img width="100px" src="https://yoratoni.com/favicon.ico" /></a>
  <h2 align="center">@yoratoni/cpp-base</h2>
  <p align="center">A basic C++ boilerplate for future projects.</p>
</p>

### Requirements
- [LLVM](https://github.com/llvm/llvm-project/releases) (Clang/clangd >= 20), the project builds in C++23.
- [CMake](https://cmake.org/download/) >= 3.21 and [Ninja](https://ninja-build.org/).
- [vcpkg](https://learn.microsoft.com/vcpkg/get_started/get-started), with the `VCPKG_ROOT` environment
  variable pointing to its installation directory.
- On Windows, the Visual Studio Build Tools ("Desktop development with C++" workload), Clang targets
  the MSVC ABI and uses the MSVC STL and Windows SDK, the Build Tools also ship CMake and Ninja.

For VSCode users, install the [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd),
[CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) and
[C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) extensions (the latter is only used
for its debugger, its IntelliSense engine is disabled in favour of clangd).

### Usage
```bash
# Configure (presets: "default", "release", "linux", "linux-release")
cmake --preset default

# Build
cmake --build --preset default

# Run the tests
ctest --test-dir build --output-on-failure
```

### Notes
- Every `.cpp` file under `src/` (except `main.cpp`) is compiled into a static library shared by the
  executable and the tests, and every `.cpp` file under `tests/` is compiled into the test executable (Catch2).
- Dependencies are added to `vcpkg.json` then found in `cmake/dependencies.cmake`, libraries that are not
  available on vcpkg can be fetched from source with `FetchContent` (pinned to a tag or commit).
- `src/core/greeting.*` and `tests/core/greeting.cpp` are placeholders, replace them with your own code.
