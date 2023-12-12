import std/[math, sequtils, strutils, tables]

type Record = tuple[line: string, groups: seq[int]]

func parseRecords(input: string): seq[Record] =
    for line in input.strip.splitLines:
        let parts = line.splitWhitespace
        result &= (line: parts[0], groups: parts[1].split(',').map(`parseInt`))

var arrangements: Table[(string, seq[int]), int]

proc countArrangements(line: string, groups: seq[int]): int =
    if line.len == 0:
        return if groups.len == 0: 1 else: 0

    if groups.len == 0:
        return if '#' in line: 0 else: 1

    if (line, groups) in arrangements:
        return arrangements[(line, groups)]

    if line[0] != '#':
        result += countArrangements(line[1..^1], groups)

    if line[0] != '.':
        if (
            groups[0] <= line.len and '.' notin line[0 ..< groups[0]]
        ) and (
            groups[0] == line.len or line[groups[0]] != '#'
        ):
            result += countArrangements(line[min(line.len, groups[0] + 1) ..^ 1], groups[1 ..^ 1])

    arrangements[(line, groups)] = result

proc countArrangements(record: Record): int =
    countArrangements(record.line, record.groups)

func partOne(input: string): string =
    let records = input.parseRecords

    $records.map(`countArrangements`).sum

func partTwo(input: string): string =
    const folds = 5

    let records = input.parseRecords.mapIt:
        let unfoldedLine = @[it.line].cycle(folds).join("?")
        let unfoldedGroups = it.groups.cycle(folds)
        (line: unfoldedLine, groups: unfoldedGroups)

    $records.map(`countArrangements`).sum



const day* = (partOne, partTwo)
