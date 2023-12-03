import std/[re, sequtils, strutils, sugar]

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
}

func foldLines(input: string, iter: ((uint, string) {.noSideEffect.} -> uint)): string =
    $input.strip.splitLines.foldl(iter(a, b), 0'u)

func partOne*(input: string): string =
    func iter(acc: uint, line: string): uint =
        let matches = line.findAll("""\d""".re)
        let number = (matches[0] & matches[^1]).parseUInt
        acc + number

    foldLines(input, `iter`)


func partTwo*(input: string): string =
    # ugly as hell but whatever
    func getMatchesFrom(i: int, line: string): seq[string] =
        if line[i].isDigit:
            @[$line[i]]
        else:
            spelledNumbers.filterIt(line[i .. ^1].startsWith(it[0])).mapIt(it[1])

    func iter(acc: uint, line: string): uint =
        var matches: seq[string] = @[]

        for i in 0 ..< line.len:
            matches &= getMatchesFrom(i, line)

        acc + (matches[0] & matches[^1]).parseUInt

    foldLines(input, `iter`)
