import std/[sequtils, sets, strutils]

type
    Point = tuple[x: int, y: int]
    Emptyness = tuple[rows: HashSet[int], columns: HashSet[int]]
    Universe = tuple[galaxies: seq[Point], emptyness: Emptyness]

func parseUniverse(input: string): Universe =
    let lines = input.strip.splitLines

    let height = lines.len
    let width = lines[0].len

    for y, line in lines:
        for x, point in line:
            if point == '#':
                result.galaxies &= (x, y)

    for y in 0 ..< height:
        if not result.galaxies.anyIt(it.y == y):
            result.emptyness.rows.incl(y)

    for x in 0 ..< width:
        if not result.galaxies.anyIt(it.x == x):
            result.emptyness.columns.incl(x)

func distanceBetween(universe: Universe, a: Point, b: Point, expansion: int): int =
    result = (a.x - b.x).abs + (a.y - b.y).abs

    for row in min(a.y, b.y) .. max(a.y, b.y):
        if row in universe.emptyness.rows:
            result += (expansion - 1)

    for column in min(a.x, b.x) .. max(a.x, b.x):
        if column in universe.emptyness.columns:
            result += (expansion - 1)


func sumGalaxyDistances(universe: Universe, expansion: int): int =
    for i, g1 in universe.galaxies:
        for j, g2 in universe.galaxies[i + 1 .. ^1]:
            result += universe.distanceBetween(g1, g2, expansion)

func partOne(input: string): string =
    let universe = input.parseUniverse
    $universe.sumGalaxyDistances(expansion = 2)

func partTwo(input: string): string =
    let universe = input.parseUniverse
    $universe.sumGalaxyDistances(expansion = 1_000_000)

const day* = (partOne, partTwo)
