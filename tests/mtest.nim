import std/[unittest, strutils, tables]
import day

export unittest

template testDay*(dayNumber: int, body: untyped) =
    suite "Day " & $dayNumber:
        block:
            let day {.inject.} = days[dayNumber]
            body

template withInput*(value: string, body: untyped) =
    block:
        let input {.inject.} = value.dedent
        body

template expectPartOne*(expect: string) =
    test "Part 1":
        check(day.partOne(input) == expect)

template expectPartTwo*(expect: string) =
    test "Part 2":
        check(day.partTwo(input) == expect)

