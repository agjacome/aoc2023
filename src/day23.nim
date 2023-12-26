import std/[sets, strutils, sugar, tables]

type
    Point = tuple[x: int, y: int]
    Map = tuple[size: int, grid: Table[Point, char]]

    Deltas = (char {.noSideEffect.} -> seq[tuple[dx: int, dy: int]])
    State = tuple[current: Point, distance: int, visited: HashSet[Point]]

func startPoint(map: Map): Point =
    result = (x: 1, y: 0)
    assert result in map.grid

func endPoint(map: Map): Point =
    result = (x: map.size - 2, y: map.size - 1)
    assert result in map.grid

func neighbors(map: Map, point: Point, deltas: Deltas): seq[Point] =
    for (dx, dy) in deltas(map.grid[point]):
        let neighbor = (point.x + dx, point.y + dy)

        if neighbor in map.grid:
            result &= (point.x + dx, point.y + dy)

func vertices(map: Map, deltas: Deltas): HashSet[Point] =
    result.incl(map.startPoint)
    result.incl(map.endPoint)

    for point, _ in map.grid:
        if map.neighbors(point, deltas).len > 2:
            result.incl(point)

func distances(map: Map, deltas: Deltas): Table[Point, Table[Point, int]] =
    let vertices = map.vertices(deltas)

    for source in vertices:
        var stack: seq[State] = @[(
            current: source,
            distance: 0,
            visited: initHashSet[Point]()
        )]

        while stack.len > 0:
            let (current, distance, visited) = stack.pop

            if current in visited:
                continue

            if distance > 0 and current in vertices:
                if source notin result:
                    result[source] = initTable[Point, int]()

                result[source][current] = distance
                continue

            for neighbor in map.neighbors(current, deltas):
                stack &= (
                    current: neighbor,
                    distance: distance + 1,
                    visited: visited + [current].toHashSet
                )

func longestPath(map: Map, deltas: Deltas): int =
    let
        startPoint = map.startPoint
        endPoint = map.endPoint
        distances = map.distances(deltas)

    var stack: seq[State] = @[(
        current: startPoint,
        distance: 0,
        visited: initHashSet[Point]()
    )]

    while stack.len > 0:
        let (current, distance, visited) = stack.pop

        if current in visited:
            continue

        if current == endPoint:
            result = result.max(distance)
            continue

        for p, d in distances[current]:
            stack &= (
                current: p,
                distance: distance + d,
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
    func deltas(value: char): seq[tuple[dx: int, dy: int]] =
        case value:
            of '>': @[(1, 0)]
            of '<': @[(-1, 0)]
            of '^': @[(0, -1)]
            of 'v': @[(0, 1)]
            else: @[(-1, 0), (1, 0), (0, -1), (0, 1)]

    $input.parseMap.longestPath(deltas)

func partTwo(input: string): string =
    func deltas(_: char): seq[tuple[dx: int, dy: int]] =
        @[(-1, 0), (1, 0), (0, -1), (0, 1)]

    $input.parseMap.longestPath(deltas)

const day* = (partOne, partTwo)
