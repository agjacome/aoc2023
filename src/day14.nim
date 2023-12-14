import std/[algorithm, sequtils, strutils, sugar, tables]
import utils

type
    Direction = enum North, West, South, East
    Rock = enum Round = "O", Square = "#", Empty = "."
    Grid = seq[seq[Rock]]

func parseGrid(input: string): Grid =
    input.strip.splitLines
        .map(line => line.mapIt(parseEnum($it, Empty)))

func sort(rocks: seq[Rock], direction: Direction): seq[Rock] =
    case direction:
        of North, West: rocks.sorted(Ascending)
        of East, South: rocks.sorted(Descending)

func transpose(grid: Grid, direction: Direction): Grid =
    case direction:
        of North, South: grid.transpose
        of East, West: grid

func tilt(grid: Grid, direction: Direction): Grid =
    grid.transpose(direction)
        .map(row => row.split(Square).mapIt(it.sort(direction)).join(Square))
        .transpose(direction)

func spin(grid: Grid): Grid =
    Direction.foldl(first = grid, operation = a.tilt(b))

func spin(grid: Grid, times: int): Grid =
    var seen: OrderedTable[Grid, int]

    var current = grid
    for i in 0 ..< times:
        if current in seen:
            let start = seen[current]
            let index = start + (times - start) mod (i - start)
            return seen.keys.toSeq[index]

        seen[current] = i
        current = current.spin

    current

func countLoad(grid: Grid): int =
    for row, rocks in grid:
        result += rocks.count(Round) * (grid.len - row)

func partOne(input: string): string =
    $input.parseGrid.tilt(North).countLoad

func partTwo(input: string): string =
    $input.parseGrid.spin(1_000_000_000).countLoad

const day* = (partOne, partTwo)
