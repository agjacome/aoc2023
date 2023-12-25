import std/[algorithm, sequtils, strutils, tables]

type
    Coordinate = tuple[x: int, y: int, z: int]
    Brick = tuple[a: Coordinate, b: Coordinate]

func drop(brick: Brick, dz: int): Brick =
    result.a = (x: brick.a.x, y: brick.a.y, z: brick.a.z - dz)
    result.b = (x: brick.b.x, y: brick.b.y, z: brick.b.z - dz)

func drop(brick: Brick, heights: Table[(int, int), int]): Brick =
    var peak = 0
    for y in brick.a.y .. brick.b.y:
        for x in brick.a.x .. brick.b.x:
            let height = heights.getOrDefault((x, y), 0)
            peak = peak.max(height)

    brick.drop(dz = max(0, brick.a.z - peak - 1))

func drop(bricks: seq[Brick]): tuple[supports: int, bricks: seq[Brick]] =
    var heights: Table[(int, int), int]

    for brick in bricks:
        let dropped = brick.drop(heights)
        if dropped.a.z != brick.a.z:
            result.supports += 1

        result.bricks &= dropped

        for x in brick.a.x .. brick.b.x:
            for y in brick.a.y .. brick.b.y:
                heights[(x, y)] = dropped.b.z

func parseBricks(input: string): seq[Brick] =
    for line in input.strip.splitLines:
        let parts = line.split('~')

        let a = parts[0].split(',').map(`parseInt`)
        let b = parts[1].split(',').map(`parseInt`)

        let brick = ((a[0], a[1], a[2]), (b[0], b[1], b[2]))
        result &= brick

func partOne(input: string): string =
    let bricks = input.parseBricks.sortedByIt(it.a.z)
    let dropped = bricks.drop.bricks

    var total = 0
    for i in 0 .. dropped.high:
        let disintegrated = dropped[0 ..< i] & dropped[i + 1 .. ^1]
        if disintegrated.drop.supports == 0:
            total += 1

    $total

func partTwo(input: string): string =
    let bricks = input.parseBricks.sortedByIt(it.a.z)
    let dropped = bricks.drop.bricks

    var total = 0
    for i in 0 .. dropped.high:
        let disintegrated = dropped[0 ..< i] & dropped[i + 1 .. ^1]
        total += disintegrated.drop.supports

    $total

const day* = (partOne, partTwo)
