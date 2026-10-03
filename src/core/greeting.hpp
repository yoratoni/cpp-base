#pragma once

#include <string>
#include <string_view>

namespace core {

/**
 * Builds the greeting message for the given name.
 * @param name The name to greet.
 * @returns The greeting message.
 */
std::string greet(std::string_view name);

} // namespace core
