import std/[deques, math, sequtils, sets, strutils, sugar, tables]

type
    Direction = enum Top, Bottom, Left, Right
    Position = tuple[x: int, y: int]
    Grid = Table[Position, char]

func parseGrid(input: string): tuple[start: Position, grid: Grid] =
    let lines = input.strip.splitLines

    for y, line in lines:
        for x, tile in line.strip:
            if tile == 'S':
                result.start = (x, y)
            result.grid[(x, y)] = tile

func isValidMove(direction: Direction, current: char, next: char): bool =
    case direction:
        of Top: current in {'S', '|', 'J', 'L'} and next in {'|', '7', 'F'}
        of Bottom: current in {'S', '|', '7', 'F'} and next in {'|', 'J', 'L'}
        of Left: current in {'S', '-', 'J', '7'} and next in {'-', 'L', 'F'}
        of Right: current in {'S', '-', 'L', 'F'} and next in {'-', 'J', '7'}

iterator neighbors(grid: Grid, p: Position): Position =
    let adjacents = {
        Top: (p.x, p.y - 1),
        Bottom: (p.x, p.y + 1),
        Left: (p.x - 1, p.y),
        Right: (p.x + 1, p.y),
    }.toTable

    let current = grid[p]
    for direction, next in adjacents:
        if next in grid and direction.isValidMove(current, grid[next]):
            yield next

func findCycle(grid: Grid, start: Position): HashSet[Position] =
    var frontier = [start].toDeque

    while frontier.len > 0:
        let position = frontier.popFirst
        result.incl(position)

        for neighbor in grid.neighbors(position):
            if neighbor notin result:
                frontier.addLast(neighbor)

iterator shootRays(
    grid: Grid,
    boundary: HashSet[Position],
    move: (Position {.noSideEffect.} -> Position)
): seq[Position] =
    for position in grid.keys:
        if position in boundary:
            continue

        var traversed: seq[Position]

        var current = position
        while current in grid:
            if current in boundary:
                traversed &= current

            current = current.move

        yield traversed

func countEnclosedTiles(grid: Grid, boundary: HashSet[Position]): int =
    func downRight(p: Position): Position = (x: p.x + 1, y: p.y + 1)
    func isCorner(p: Position): bool = grid[p] == '7' or grid[p] == 'L'

    for traversed in grid.shootRays(boundary, move = downRight):
        let count = traversed.mapIt(if it.isCorner: 2 else: 1).sum
        result += count mod 2

func partOne(input: string): string =
    let (start, grid) = input.parseGrid
    let cycle = grid.findCycle(start)

    $(cycle.len div 2)

func partTwo(input: string): string =
    let (start, grid) = input.parseGrid
    let cycle = grid.findCycle(start)

    $grid.countEnclosedTiles(cycle)

const day* = (partOne, partTwo)
