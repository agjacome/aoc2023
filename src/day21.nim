import std/[sets, strutils]

type
    Point = tuple[x: int, y: int]
    Map = tuple[size: int, start: Point, garden: HashSet[Point]]

iterator neighbors(point: Point): Point =
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
        yield (x: point.x + dx, y: point.y + dy)

func `mod`(point: Point, n: int): Point =
    result.x = point.x mod n
    result.x = if result.x < 0: result.x + n else: result.x

    result.y = point.y mod n
    result.y = if result.y < 0: result.y + n else: result.y

func reachable(map: Map, steps: int, count: int = 1): seq[int] =
    var queue = [map.start].toHashSet

    for step in 1 .. steps:
        var frontier: HashSet[Point]

        for current in queue:
            for neighbor in current.neighbors:
                if neighbor in map.garden:
                    frontier.incl(neighbor)

                if (neighbor mod map.size) in map.garden:
                    frontier.incl(neighbor)

        queue = frontier

        if step mod map.size == steps mod map.size:
            result &= queue.len

        if result.len == count: break

func parseMap(input: string): Map =
    let lines = input.strip.splitLines

    result.size = lines.len

    for y, line in lines:
        for x, char in line:
            if char == 'S':
                result.start = (x, y)
            if char != '#':
                result.garden.incl((x, y))

func quadratic(a, b, c, x: int): int =
    a + (b * x) + (x * (x - 1) div 2) * (c - b)

func partOne(input: string): string =
    const steps = 64

    let map = input.parseMap
    let reachable = map.reachable(steps, count = 1)

    $reachable[0]

func partTwo(input: string): string =
    const steps = 26501365

    let map = input.parseMap
    let reachable = map.reachable(steps, count = 3)

    $quadratic(
        a = reachable[0],
        b = reachable[1] - reachable[0],
        c = reachable[2] - reachable[1],
        x = steps div map.size
    )

const day* = (partOne, partTwo)
