{.experimental: "caseStmtMacros".}

import fusion/matching
import std/[options, os, strformat, strutils, sugar, tables]

import day

type Solution = tuple[partOne: string, partTwo: string]

proc solveDay(n: int, input: string): Option[Solution] =
    if n notin days:
        return Solution.none

    let day = days[n]
    (partOne: day.partOne(input), partTwo: day.partTwo(input)).some

proc main(day: string, file: string) =
    case solveDay(n = parseInt(day), input = readFile(file)):
        of Some(Solution(partOne: @part1, partTwo: @part2)):
            echo "Part 1: {part1}".fmt
            echo "Part 2: {part2}".fmt
        of None():
            echo "No solution found for Day {paramStr(1)}".fmt
            quit(QuitFailure)

when isMainModule:
    main(paramStr(1), paramStr(2))
