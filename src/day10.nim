import std/[deques, sequtils, sets, strutils, tables]

type
    Direction = enum Top, Bottom, Left, Right
    Position = tuple[x: int, y: int]
    Grid = Table[Position, char]

func parseGrid(input: string): tuple[start: Position, grid: Grid] =
    let lines = input.strip.splitLines

    for y, line in lines:
        for x, pipe in line.strip:
            if pipe == 'S':
                result.start = (x, y)
            result.grid[(x, y)] = pipe

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

func bfsCover(grid: Grid, start: Position): HashSet[Position] =
    var frontier = [start].toDeque

    while frontier.len > 0:
        let position = frontier.popFirst
        result.incl(position)

        for neighbor in grid.neighbors(position):
            if neighbor notin result:
                frontier.addLast(neighbor)

func partOne(input: string): string =
    let (start, grid) = input.parseGrid
    let seen = grid.bfsCover(start)

    $(seen.len div 2)

func partTwo(input: string): string =
    "TODO"

const day* = (partOne, partTwo)
