import std/[algorithm, sequtils, strutils]

type Grid = seq[seq[char]]

iterator parseGrids(input: string): Grid =
    for grid in input.strip.split("\n\n"):
        yield grid.splitLines.mapIt(it.toSeq)

func transpose(grid: Grid): Grid =
    result = newSeq[seq[char]](grid[0].len)

    for j, row in grid:
        for i, char in row:
            if result[i].len == 0:
                result[i] = newSeq[char](grid.len)

            result[i][j] = char

func findReflectionLine(grid: Grid): int =
    for i in 1 ..< grid.len:
        let top = grid[0 ..< i].reversed
        let bottom = grid[i ..^ 1]

        let len = min(top.len, bottom.len)
        if top[0 ..< len] == bottom[0 ..< len]:
            return i

func partOne(input: string): string =
    var summary = 0

    for grid in input.parseGrids:
        let horizontal = grid.findReflectionLine
        let vertical = grid.transpose.findReflectionLine

        summary += (horizontal * 100) + vertical

    $summary

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
