import std/[sets, strutils, tables]

type
    Point = tuple[x: int, y: int]
    Map = tuple[size: int, grid: Table[Point, char]]

iterator neighbors(map: Map, point: Point): Point =
    let deltas = case map.grid[point]:
        of '>': @[(1, 0)]
        of '<': @[(-1, 0)]
        of '^': @[(0, -1)]
        of 'v': @[(0, 1)]
        else: @[(-1, 0), (1, 0), (0, -1), (0, 1)]

    for (dx, dy) in deltas:
        let neighbor = (point.x + dx, point.y + dy)
        if neighbor in map.grid:
            yield neighbor

func longestPath(map: Map, startPoint, endPoint: Point): seq[Point] =
    type State = tuple
        current: Point
        path: seq[Point]
        visited: HashSet[Point]

    var stack: seq[State] = @[(
        current: startPoint,
        path: @[],
        visited: initHashSet[Point]()
    )]

    while stack.len > 0:
        let (current, path, visited) = stack.pop

        if current == endPoint:
            if result.len < path.len:
                result = path
            continue

        for neighbor in map.neighbors(current):
            if neighbor notin visited:
                stack &= (
                    current: neighbor,
                    path: path & current,
                    visited: visited + [current].toHashSet
                )

func parseMap(input: string): Map =
    let lines = input.strip.splitLines

    result.size = lines.len
    for y, line in lines:
        for x, char in line:
            if char != '#':
                result.grid[(x, y)] = char

func partOne(input: string): string =
    let map = input.parseMap

    let path = map.longestPath(
        startPoint = (x: 1, y: 0),
        endPoint = (x: map.size - 2, y: map.size - 1)
    )

    $path.len

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
