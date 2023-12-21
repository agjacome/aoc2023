import std/[deques, sequtils, sets, strutils]

type
    Point = tuple[x: int, y: int]
    Map = tuple[start: Point, garden: HashSet[Point]]

func neighbors(garden: HashSet[Point], point: Point): HashSet[Point] =
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
        let neighbor = (point.x + dx, point.y + dy)

        if neighbor in garden:
            result.incl(neighbor)

func countReachable(map: Map, totalSteps: int): int =
    var reachable: HashSet[Point]

    var visited: HashSet[Point]
    var queue = [(point: map.start, steps: 0)].toDeque

    while queue.len > 0:
        var current = queue.popFirst

        if current.steps mod 2 == 0:
            reachable.incl(current.point)

        if current.steps == totalSteps: continue
        if current.point in visited: continue

        visited.incl(current.point)

        for neighbor in map.garden.neighbors(current.point):
            if neighbor notin visited:
                queue.addLast((point: neighbor, steps: current.steps + 1))

    reachable.len

func parseMap(input: string): Map =
    for y, line in input.strip.splitLines.toSeq:
        for x, char in line:
            let point = (x, y)
            if char == 'S': result.start = point
            if char != '#': result.garden.incl(point)

func partOne(input: string): string =
    $input.parseMap.countReachable(64)

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
