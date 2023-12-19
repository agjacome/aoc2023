import std/strutils

type
    Point = tuple[x: int, y: int]
    Direction = tuple[dx: int, dy: int]
    DigPlan = seq[tuple[direction: Direction, distance: int]]

func parseDirection(direction: string): Direction =
    case direction:
        of "U", "3": (dx: 0, dy: -1)
        of "D", "1": (dx: 0, dy: 1)
        of "L", "2": (dx: -1, dy: 0)
        of "R", "0": (dx: 1, dy: 0)
        else: raise newException(ValueError, "Invalid direction: " & direction)

func parseDigPlan(input: string): DigPlan =
    for line in input.strip.splitLines:
        let parts = line.splitWhitespace

        let direction = parts[0].parseDirection
        let distance = parts[1].parseInt
        result &= (direction, distance)

func parseHexDigPlan(input: string): DigPlan =
    for line in input.strip.splitLines:
        let hex = line.splitWhitespace[2]

        let direction = hex[^2..^2].parseDirection
        let distance = hex[2..^3].parseHexInt
        result &= (direction, distance)


func next(point: Point, direction: Direction, distance: int): Point =
    result.x = point.x + direction.dx * distance
    result.y = point.y + direction.dy * distance

func shoelaceArea(points: seq[Point], perimeter: int): int =
    var area = 0
    for i in 0 ..< points.high:
        let x = points[i].x - points[i + 1].x
        let y = points[i].y + points[i + 1].y
        area += y * x

    (perimeter + area.int) div 2 + 1

func dig(plan: DigPlan): int =
    var perimeter = 0
    var points = @[(x: 0, y: 0)]

    for (direction, distance) in plan:
        points &= points[^1].next(direction, distance)
        perimeter += distance

    points.shoelaceArea(perimeter)

func partOne(input: string): string =
    $input.parseDigPlan.dig

func partTwo(input: string): string =
    $input.parseHexDigPlan.dig

const day* = (partOne, partTwo)
