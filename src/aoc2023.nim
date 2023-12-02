import std/[options, os, strformat, strutils]
import system

import day01

func solveDay(day: int, input: string): Option[(string, string)] =
    case day:
        of 1:
            some((day01.partOne(input), day01.partTwo(input)))
        else:
            none((string, string))

when isMainModule:
    let solution = solveDay(
        day = parseInt(paramStr(1)),
        input = readFile(paramStr(2))
    )

    if solution.isNone:
        echo "No solution found for Day {paramStr(1)}".fmt
        quit(QuitFailure)

    let (part1, part2) = solution.get
    echo "Part 1: {part1}".fmt
    echo "Part 2: {part2}".fmt
