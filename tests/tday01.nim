import std/[unittest, strutils]

import day01

suite "Day 01":
    test "Part 1":
        const input = """
            1abc2
            pqr3stu8vwx
            a1b2c3d4e5f
            treb7uchet
        """.dedent;

        const expected = "142"

        check(partOne(input) == expected)

    test "Part 2":
        const input = """
            two1nine
            eightwothree
            abcone2threexyz
            xtwone3four
            4nineeightseven2
            zoneight234
            7pqrstsixteen
        """.dedent;

        const expected = "281"

        check(partTwo(input) == expected)
