{.experimental: "caseStmtMacros".}

import fusion/matching
import std/[options, os, strformat, strutils]
import system

import day01
import day02

func solveDay(day: int, input: string): Option[(string, string)] =
    case day:
        of 1: (day01.partOne(input), day01.partTwo(input)).some
        of 2: (day02.partOne(input), day02.partTwo(input)).some
        else: (string, string).none

when isMainModule:
    case solveDay(day = parseInt(paramStr(1)), input = readFile(paramStr(2))):
        of Some((@part1, @part2)):
            echo "Part 1: {part1}".fmt
            echo "Part 2: {part2}".fmt
        of None():
            echo "No solution found for Day {paramStr(1)}".fmt
            quit(QuitFailure)
