#include "core/greeting.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("greet", "[core]") {
    REQUIRE(core::greet("World") == "Hello, World!");
    REQUIRE(core::greet("") == "Hello, !");
}
