import std/[algorithm, sequtils, strutils, sugar]
import utils

type
    Rock = enum Round = "O", Square = "#", Empty = "."
    Grid = seq[seq[Rock]]

func parseGrid(input: string): Grid =
    input.strip.splitLines.map(
        line => line.mapIt(parseEnum($it, Empty))
    )

func tiltNorth(grid: Grid): Grid =
    var tilted: Grid

    for row in grid.transpose:
        tilted &= row.split(Square).mapIt(it.sorted).join(Square)

    tilted.transpose

func countLoad(grid: Grid): int =
    for i, row in grid:
        result += row.countIt(it == Round) * (grid.len - i)

func partOne(input: string): string =
    $input.parseGrid.tiltNorth.countLoad

func partTwo(input: string): string =
    "TODO"

const day* = (partOne, partTwo)
