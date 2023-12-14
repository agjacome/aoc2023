import std/[unittest, strutils, sugar, tables]
import utils

suite "Utils - sequences":
    test "transpose matrix":
        let
            input = @[@[1, 2, 3], @[4, 5, 6], @[7, 8, 9]]
            expected = @[@[1, 4, 7], @[2, 5, 8], @[3, 6, 9]]

        check(input.transpose == expected)

    test "transpose non-square matrix":
        let
            input = @[@[1, 2, 3], @[7, 8, 9]]
            expected = @[@[1, 7], @[2, 8], @[3, 9]]

        check(input.transpose == expected)

    test "split by predicate":
        let
            input = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
            expected = @[@[1, 2], @[4, 5, 6, 7, 8, 9]]

        check(input.split((x: int) => x == 3) == expected)

    test "split by falsy predicate":
        let
            input = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
            expected = @[@[1, 2, 3, 4, 5, 6, 7, 8, 9]]

        check(input.split((x: int) => x == 10) == expected)

    test "split by element":
        let
            input = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
            expected = @[@[1, 2], @[4, 5, 6, 7, 8, 9]]

        check(input.split(3) == expected)

    test "split by non-existing element":
        let
            input = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
            expected = @[@[1, 2, 3, 4, 5, 6, 7, 8, 9]]

        check(input.split(10) == expected)

    test "join sequences":
        let
            input = @[@[1, 2], @[4, 5, 6, 7, 8, 9]]
            expected = @[1, 2, 42, 4, 5, 6, 7, 8, 9]

        check(input.join(42) == expected)
