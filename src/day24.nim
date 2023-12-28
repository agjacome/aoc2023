import std/[options, sequtils, strutils]

type
    Vector = tuple[x, y, z: float64]
    Line = tuple[a, b, c: float64]
    Plane = tuple[vector: Vector, scalar: float64]
    Hailstone = object
        position: Vector
        velocity: Vector

func intersects(l1, l2: Line): bool =
    l1.a * l2.b != l1.b * l2.a

func `-`(a, b: Vector): Vector =
    result.x = a.x - b.x
    result.y = a.y - b.y
    result.z = a.z - b.z

func `/`(a: Vector, b: float64): Vector =
    result.x = a.x / b
    result.y = a.y / b
    result.z = a.z / b

func `×`(a, b: Vector): Vector =
    result.x = a.y * b.z - a.z * b.y
    result.y = a.z * b.x - a.x * b.z
    result.z = a.x * b.y - a.y * b.x

func dot(a, b: Vector): float64 =
    a.x * b.x + a.y * b.y + a.z * b.z

func dependent(a, b: Vector): bool =
    a × b == (x: 0'f64, y: 0'f64, z: 0'f64)

func prod(
    r, s, t: float64,
    a, b, c: Vector
): Vector =
    result.x = r * a.x + s * b.x + t * c.x
    result.y = r * a.y + s * b.y + t * c.y
    result.z = r * a.z + s * b.z + t * c.z

func line(h: Hailstone): Line =
    result.a = h.velocity.y
    result.b = -(h.velocity.x)
    result.c = (h.position.x * h.velocity.y) - (h.position.y * h.velocity.x)

func plane(h1, h2: Hailstone): Plane =
    let pos = h1.position - h2.position
    let vel = h1.velocity - h2.velocity

    result.vector = pos × vel
    result.scalar = pos.dot(h1.velocity × h2.velocity)

func findRock(hailstones: array[3, Hailstone]): Vector =
    let p1 = hailstones[0].plane(hailstones[1])
    let p2 = hailstones[0].plane(hailstones[2])
    let p3 = hailstones[1].plane(hailstones[2])

    let t = p1.vector.dot(p2.vector × p3.vector)

    let w = prod(
        p1.scalar, p2.scalar, p3.scalar,
        p2.vector × p3.vector,
        p3.vector × p1.vector,
        p1.vector × p2.vector
    ) / t

    let w1 = hailstones[0].velocity - w
    let w2 = hailstones[1].velocity - w
    let w3 = w1 × w2

    prod(
        w3.dot(hailstones[1].position × w2),
        -w3.dot(hailstones[0].position × w1),
        w3.dot(hailstones[0].position),
        w1, w2, w3
    ) / w3.dot(w3)

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

    (x: x, y: y, z: 0'f64).some

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

func partTwo(input: string): string =
    let hailstones = input.parseHailstones

    var independent: array[3, Hailstone]
    independent[0] = hailstones[0]

    var (i, j) = (1, 2)
    while i < hailstones.len and j < hailstones.len:
        independent[1] = hailstones[i]
        independent[2] = hailstones[j]

        if independent[0].velocity.dependent(independent[1].velocity):
            i += 1
            j += 1
        elif independent[0].velocity.dependent(independent[2].velocity):
            j += 1
        elif independent[1].velocity.dependent(independent[2].velocity):
            j += 1
        else:
            break

    let rock = independent.findRock
    $(rock.x + rock.y + rock.z).toInt

const day* = (partOne, partTwo)
