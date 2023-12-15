import std/[math, sequtils, strutils, tables]

type
    Sequence = seq[string]

    StepKind = enum Insert, Remove
    StepAction = object
        label: string
        case kind: StepKind:
            of Insert:
                focalLength: int
            of Remove:
                discard

    Box = OrderedTable[string, int]
    Boxes = array[256, Box]

func parseSequence(input: string): Sequence =
    input.strip.split(",")

func hash(str: string): int =
    str.foldl((a + b.ord) * 17 mod 256, 0)

func action(step: string): StepAction =
    let parts = step.split({'-', '='})

    if parts[1].len > 0:
        return StepAction(kind: Insert, label: parts[0], focalLength: parts[1].parseInt)
    else:
        return StepAction(kind: Remove, label: parts[0])

func verify(sequence: Sequence): int =
    sequence.map(`hash`).sum

func initialize(sequence: Sequence): Boxes =
    for step in sequence:
        let action = step.action
        let index = action.label.hash

        case action.kind:
            of Insert: result[index][action.label] = action.focalLength
            of Remove: result[index].del(action.label)

func focusingPower(boxes: Boxes): int =
    for i, box in boxes:
        for j, focalLength in box.values.toSeq:
            result += (i + 1) * (j + 1) * focalLength

func partOne(input: string): string =
    $input.parseSequence.verify

func partTwo(input: string): string =
    $input.parseSequence.initialize.focusingPower

const day* = (partOne, partTwo)
