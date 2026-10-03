#include "core/greeting.hpp"

#include <format>

namespace core {

std::string greet(std::string_view name) {
    return std::format("Hello, {}!", name);
}

} // namespace core
