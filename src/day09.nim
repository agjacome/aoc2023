import std/[sequtils, strutils]

iterator parseHistories(input: string): seq[int] =
    for line in input.strip.splitLines:
        yield line.splitWhitespace.map(`parseInt`)

func differences(history: seq[int]): seq[int] =
    history.zip(history[1..^1]).mapIt(it[1] - it[0])

func extrapolate(history: seq[int]): int =
    var previous = history

    while previous.anyIt(it != 0):
        result += previous[^1]
        previous = previous.differences

func partOne(input: string): string =
    var sum = 0
    for history in input.parseHistories:
        sum += history.extrapolate

    $sum

func partTwo(input: string): string =
    "TODO"

const day* = (partOne: partOne, partTwo: partTwo)
