{.experimental: "caseStmtMacros".}

import fusion/matching
import std/[options, os, strformat, strutils]

import day

proc main(day: string, file: string) =
    let day = parseInt(day)
    let input = readFile(file)

    case day.solve(input):
        of Some((@part1, @part2)):
            echo "Part 1: {part1}".fmt
            echo "Part 2: {part2}".fmt
        of None():
            echo "No solution found for Day {paramStr(1)}".fmt
            quit(QuitFailure)

when isMainModule:
    main(paramStr(1), paramStr(2))
