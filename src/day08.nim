import std/[math, sequtils, strscans, strutils, tables]

type
    Network = Table[string, tuple[left: string, right: string]]
    Direction = enum Right, Left

func parse(input: string): (seq[Direction], Network) =
    let documents = input.strip.split("\n\n")

    result[0] = documents[0].mapIt:
        case it:
            of 'R': Direction.Right
            of 'L': Direction.Left
            else: raise newException(ValueError, "Invalid direction: " & it)

    for line in documents[1].strip.splitLines:
        var value, left, right: string
        if line.scanf("$+ = ($+, $+)", value, left, right):
            result[1][value] = (left, right)
        else:
            raise newException(ValueError, "Invalid node: " & line)

func countSteps(
    network: Network,
    directions: seq[Direction],
    startNodes: seq[string],
    endNodes: seq[string],
): CountTable[string] =
    var frontier = startNodes.mapIt((it, it))

    while frontier.len > 0:
        let (source, current) = frontier.pop

        if current in endNodes:
            continue

        case directions[result[source] mod directions.len]:
            of Right: frontier &= (source, network[current].right)
            of Left: frontier &= (source, network[current].left)

        result.inc(source)

func partOne(input: string): string =
    let (directions, network) = input.parse

    let startNodes = @["AAA"]
    let endNodes = @["ZZZ"]

    let steps = network.countSteps(directions, startNodes, endNodes)
    $steps["AAA"]

func partTwo(input: string): string =
    let (directions, network) = input.parse

    let startNodes = network.keys.toSeq.filterIt(it.endsWith("A"))
    let endNodes = network.keys.toSeq.filterIt(it.endsWith("Z"))

    let steps = network.countSteps(directions, startNodes, endNodes)
    $steps.values.toSeq.lcm


const day* = (partOne: partOne, partTwo: partTwo)
