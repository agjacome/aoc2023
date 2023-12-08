import std/[math, sequtils, strscans, strutils, sugar, tables]

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

func countSteps(
    network: Network,
    directions: seq[Direction],
    start: seq[string],
    isEnd: (string {.noSideEffect.} -> bool)
): Table[string, int] =
    var steps: CountTable[string]
    var frontier = start.mapIt((it, it))

    while result.len < start.len:
        while frontier.len > 0:
            let (source, current) = frontier.pop

            if current.isEnd and source notin result:
                result[source] = steps[source]
                continue

            case directions[steps[source] mod directions.len]:
                of Direction.Right:
                    frontier &= (source, network[current].right)
                of Direction.Left:
                    frontier &= (source, network[current].left)

            steps.inc(source)

func partOne(input: string): string =
    let (directions, network) = input.parse

    let steps = network.countSteps(
        directions = directions,
        start = @["AAA"],
        isEnd = (s: string) => s == "ZZZ"
    )

    $steps["AAA"]

func partTwo(input: string): string =
    let (directions, network) = input.parse

    let steps = network.countSteps(
        directions = directions,
        start = network.keys.toSeq.filterIt(it.endsWith("A")),
        isEnd = (s: string) => s.endsWith("Z")
    )

    $steps.values.toSeq.lcm


const day* = (partOne: partOne, partTwo: partTwo)
