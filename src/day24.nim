import std/[options, sequtils, strutils]

type
    Vector = tuple
        x: float64
        y: float64
        z: float64

    Line = tuple
        a: float64
        b: float64
        c: float64

    Hailstone = object
        position: Vector
        velocity: Vector

func intersects(l1, l2: Line): bool =
    l1.a * l2.b != l1.b * l2.a

func line(h: Hailstone): Line =
    result.a = h.velocity.y
    result.b = -(h.velocity.x)
    result.c = (h.position.x * h.velocity.y) - (h.position.y * h.velocity.x)

func intersection(h1, h2: Hailstone): Option[Vector] =
    let l1 = h1.line
    let l2 = h2.line

    if not l1.intersects(l2): return Vector.none

    let x = (l2.b * l1.c - l1.b * l2.c) / (l1.a * l2.b - l2.a * l1.b)
    let y = (l1.a * l2.c - l2.a * l1.c) / (l1.a * l2.b - l2.a * l1.b)

    if (x - h1.position.x) * h1.velocity.x < 0: return Vector.none
    if (y - h1.position.y) * h1.velocity.y < 0: return Vector.none
    if (x - h2.position.x) * h2.velocity.x < 0: return Vector.none
    if (y - h2.position.y) * h2.velocity.y < 0: return Vector.none

    return (x: x, y: y, z: 0'f64).some

func intersections(hailstones: seq[Hailstone]): seq[Vector] =
    for i, h1 in hailstones:
        for h2 in hailstones[i + 1 .. ^1]:
            let intersection = h1.intersection(h2)

            if intersection.isSome:
                result &= intersection.get

func parseHailstones(input: string): seq[Hailstone] =
    for line in input.strip.splitLines:
        let parts = line.split('@')

        let position = parts[0].strip.split(',').mapIt(it.strip.parseFloat)
        let velocity = parts[1].strip.split(',').mapIt(it.strip.parseFloat)

        result &= Hailstone(
            position: (x: position[0], y: position[1], z: position[2]),
            velocity: (x: velocity[0], y: velocity[1], z: velocity[2])
        )

func partOne(input: string): string =
    const min = 7'f64
    const max = 27'f64
    # const min = 200_000_000_000_000'f64
    # const max = 400_000_000_000_000'f64

    $input.parseHailstones.intersections.countIt(
        it.x >= min and it.x <= max and
        it.y >= min and it.y <= max
    )

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
