import std/[sequtils, strutils]

type
    Point = tuple[x: int, y: int]
    Direction = tuple[dx: int, dy: int]
    DigPlan = seq[tuple[direction: Direction, distance: int]]

func parseDirection(direction: string): Direction =
    case direction:
        of "U": (dx: 0, dy: -1)
        of "D": (dx: 0, dy: 1)
        of "L": (dx: -1, dy: 0)
        of "R": (dx: 1, dy: 0)
        else: raise newException(ValueError, "Invalid direction: " & direction)

func parseDigPlan(input: string): DigPlan =
    for line in input.strip.splitLines:
        let parts = line.splitWhitespace

        let direction = parseDirection(parts[0])
        let distance = parts[1].parseInt
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

    shoelaceArea(points, perimeter)

func partOne(input: string): string =
    let plan = input.parseDigPlan

    $plan.dig

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
