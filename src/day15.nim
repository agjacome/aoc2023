import std/[math, sequtils, strutils, sugar]

type
    Step = seq[char]
    Sequence = seq[Step]

func parseSequence(input: string): Sequence =
    input.strip.split(",").mapIt(it.toSeq)

func hash(step: Step): int =
    step.foldl(first = 0, operation = (a + b.ord) * 17 mod 256)

func verify(sequence: Sequence): int =
    sequence.map(`hash`).sum

func partOne(input: string): string =
    $input.parseSequence.verify

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
