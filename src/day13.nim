import std/[math, sequtils, strutils]
import utils

type Grid = seq[seq[char]]

func parseGrids(input: string): seq[Grid] =
    for grid in input.strip.split("\n\n"):
        result &= grid.splitLines.mapIt(it.toSeq)

func countReflectionDifferences(grid: Grid, row: int): int =
    for rowDiff in 0 ..< min(row, grid.len - row):
        for col in 0 ..< grid[row].len:
            if grid[row + rowDiff][col] != grid[row - rowDiff - 1][col]:
                result += 1

func findReflectionLine(grid: Grid, smudges: int): int =
    for row in 1 ..< grid.len:
        if grid.countReflectionDifferences(row) == smudges:
            return row

func summarizeReflections(grid: Grid, smudges: int): int =
    let horizontal = grid.findReflectionLine(smudges)
    let vertical = grid.transpose.findReflectionLine(smudges)

    horizontal * 100 + vertical

func partOne(input: string): string =
    $input.parseGrids.mapIt(it.summarizeReflections(smudges = 0)).sum

func partTwo(input: string): string =
    $input.parseGrids.mapIt(it.summarizeReflections(smudges = 1)).sum

const day* = (partOne, partTwo)
