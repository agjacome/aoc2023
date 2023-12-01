import std/[re, sequtils, strutils, tables]

const spelledNumbers = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9"
}.toTable

func partOne*(input: string): string =
    func iter(acc: uint, line: string): uint =
        let matches = line.findAll(re"\d")
        let number = (matches[0] & matches[^1]).parseUInt
        acc + number

    $(input.strip.splitLines.foldl(iter(a, b), 0'u))

proc partTwo*(input: string): string =
    func iter(acc: uint, line: string): uint =
        var matches: seq[string]

        # ugly as hell
        for i in 0 ..< line.len:
            if isDigit(line[i]):
                matches.add($line[i])
                continue

            for spelledNumber in spelledNumbers.keys:
                if line[i .. ^1].startsWith(spelledNumber):
                    matches.add(spelledNumber)

        let first = spelledNumbers.getOrDefault(matches[0], matches[0])
        let last = spelledNumbers.getOrDefault(matches[^1], matches[^1])

        acc + (first & last).parseUInt

    $(input.strip.splitLines.foldl(iter(a, b), 0'u))
