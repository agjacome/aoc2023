import std/[math, sequtils, strutils, sugar]

func parseHistories(input: string): seq[seq[int]] =
    for line in input.strip.splitLines:
        result &= line.splitWhitespace.map(`parseInt`)

func differences(history: seq[int]): seq[int] =
    history.zip(history[1..^1]).mapIt(it[1] - it[0])

func extrapolate(
    history: seq[int],
    pick: (seq[int] {.noSideEffect.} -> int),
    accumulate: (seq[int] {.noSideEffect.} -> int)
): int =
    var predictions: seq[int]
    var previous = history

    while previous.anyIt(it != 0):
        predictions &= previous.pick
        previous = previous.differences

    predictions.accumulate

func predict(
    histories: seq[seq[int]],
    pick: (seq[int] {.noSideEffect.} -> int),
    accumulate: (seq[int] {.noSideEffect.} -> int)
): int =
    histories.mapIt(it.extrapolate(pick, accumulate)).sum

func partOne(input: string): string =
    func pickLast(difference: seq[int]): int = difference[^1]
    func accumulate(extrapolation: seq[int]): int = extrapolation.foldl(a + b)

    $input.parseHistories.predict(pickLast, accumulate)

func partTwo(input: string): string =
    func pickFirst(difference: seq[int]): int = difference[0]
    func accumulate(extrapolation: seq[int]): int = extrapolation.foldr(a - b)

    $input.parseHistories.predict(pickFirst, accumulate)

const day* = (partOne: partOne, partTwo: partTwo)
