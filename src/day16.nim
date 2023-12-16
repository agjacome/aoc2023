import fusion/matching
import std/[deques, strutils, tables, sets]

type
    Point = tuple[x: int, y: int]
    Direction = tuple[dx: int, dy: int]
    Grid = tuple[width: int, height: int, values: Table[Point, char]]

func parseGrid(input: string): Grid =
    let lines = input.strip.splitLines

    result.height = lines.len
    for y, line in lines:
        result.width = line.len
        for x, char in line.strip:
            if char != '.':
                result.values[(x, y)] = char

func next(point: Point, direction: Direction): Point =
    result.x = point.x + direction.dx
    result.y = point.y + direction.dy

func next(point: Point, direction: Direction, grid: Grid): HashSet[(Point, Direction)] =
    var next: seq[(Point, Direction)]

    case (grid.values.getOrDefault(point, '.'), direction):
        of ('/', _):
            let turn = (-direction.dy, -direction.dx)
            next &= (point.next(turn), turn)

        of ('\\', _):
            let turn = (direction.dy, direction.dx)
            next &= (point.next(turn), turn)

        of ('|', (_, 0)):
            next &= (point.next((dx: 0, dy: 1)), (dx: 0, dy: 1))
            next &= (point.next((dx: 0, dy: -1)), (dx: 0, dy: -1))

        of ('-', (0, _)):
            next &= (point.next((dx: 1, dy: 0)), (dx: 1, dy: 0))
            next &= (point.next((dx: -1, dy: 0)), (dx: -1, dy: 0))

        else:
            next &= (point.next(direction), direction)

    for (point, direction) in next:
        if point.x < 0 or point.y < 0: continue
        if point.x >= grid.width or point.y >= grid.height: continue

        result.incl((point, direction))

func beamCoverage(grid: Grid, start: Point, direction: Direction): HashSet[Point] =
    var visited: HashSet[(Point, Direction)]

    var frontier = [(start, direction)].toDeque
    while frontier.len > 0:
        let current = frontier.popFirst

        if current in visited:
            continue

        visited.incl(current)
        result.incl(current[0])

        for next in current[0].next(current[1], grid):
            frontier.addLast(next)

func partOne(input: string): string =
    let grid = input.parseGrid

    let coverage = grid.beamCoverage(
        start = (x: 0, y: 0),
        direction = (dx: 1, dy: 0)
    )

    $coverage.len

func partTwo(input: string): string =
    let grid = input.parseGrid

    var max = 0

    for x in 0 .. grid.width:
        let top = grid.beamCoverage(start = (x: x, y: 0), direction = (dx: 0, dy: 1))
        let bottom = grid.beamCoverage(start = (x: x, y: grid.height - 1), direction = (dx: 0, dy: -1))
        max = [max, top.len, bottom.len].max

    for y in 0 .. grid.height:
        let left = grid.beamCoverage(start = (x: 0, y: y), direction = (dx: 1, dy: 0))
        let right = grid.beamCoverage(start = (x: grid.width - 1, y: y), direction = (dx: -1, dy: 0))
        max = [max, left.len, right.len].max

    $max

const day* = (partOne, partTwo)
