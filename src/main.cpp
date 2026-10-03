#include "core/greeting.hpp"

#include <cstdlib>
#include <iostream>

int main() {
    std::cout << core::greet("World") << '\n';

#ifdef _WIN32
    std::system("pause");
#endif

    return EXIT_SUCCESS;
}
