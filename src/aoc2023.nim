import std/[os, strformat, strutils]
import system

import day01

proc solveDay(day: int, input: string) =
    let (part1, part2) = case day:
        of 1:
            (day01.partOne(input), day01.partTwo(input))
        else:
            echo fmt"Day {day} not found"
            quit(QuitFailure)

    echo fmt"Part 1: {part1}"
    echo fmt"Part 2: {part2}"

when isMainModule:
    solveDay(
        day = parseInt(paramStr(1)),
        input = readFile(paramStr(2))
    )
