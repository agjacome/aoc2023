import std/[unittest, strutils]

import day01

suite "Day 01":
    test "Part 1":
        let input = """
            1abc2
            pqr3stu8vwx
            a1b2c3d4e5f
            treb7uchet
        """.dedent;

        let expected = "142"
        let solution = partOne(input)

        check(solution == expected)

    test "Part 2":
        let input = """
            two1nine
            eightwothree
            abcone2threexyz
            xtwone3four
            4nineeightseven2
            zoneight234
            7pqrstsixteen
        """.dedent;

        let expected = "281"
        let solution = partTwo(input)

        check(solution == expected)
