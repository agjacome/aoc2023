import std/[sequtils, strscans, strutils, tables]

type
    Network = Table[string, tuple[left: string, right: string]]
    Direction = enum Right, Left

func parse(input: string): (seq[Direction], Network) =
    let documents = input.strip.split("\n\n")

    result[0] = documents[0].mapIt:
        case it:
            of 'R': Direction.Right
            of 'L': Direction.Left
            else: raise newException(ValueError, "Invalid direction")

    for line in documents[1].strip.splitLines:
        var value, left, right: string
        if line.scanf("$+ = ($+, $+)", value, left, right):
            result[1][value] = (left, right)

func partOne(input: string): string =
    let (directions, network) = input.parse

    var steps = 0
    var current = "AAA"

    while current != "ZZZ":
        if current notin network:
            raise newException(ValueError, "Invalid network")

        let direction = directions[steps mod directions.len]
        let (left, right) = network[current]
        current = if direction == Direction.Right: right else: left

        steps += 1

    $steps

func partTwo(input: string): string =
    "TODO"

const day* = (partOne: partOne, partTwo: partTwo)
