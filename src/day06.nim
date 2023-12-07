import std/[math, sequtils, strutils, sugar]

type RaceRecord = tuple[time: uint, distance: uint]

func countWaysToWin(record: RaceRecord): int =
    let half = (1'u .. record.time div 2).countIt:
        it * (record.time - it) > record.distance

    half * 2 - (if record.time mod 2 == 0: 1 else: 0)

func multiplyWaysToWin(records: seq[RaceRecord]): int =
    records.map(`countWaysToWin`).prod

func parseRaceRecords(input: string, parseNums: (string {.noSideEffect.} -> seq[uint])): seq[RaceRecord] =
    let lines = input.strip.splitLines

    let times = lines[0].split(":")[1].strip.parseNums
    let distances = lines[1].split(":")[1].strip.parseNums

    times.zip(distances).mapIt((time: it[0], distance: it[1]))

func multiRecord(input: string): seq[uint] =
    input.splitWhitespace.map(`parseUInt`)

func singleRecord(input: string): seq[uint] =
    @[input.replace(" ", "").parseUInt]

func partOne(input: string): string =
    $input.parseRaceRecords(`multiRecord`).multiplyWaysToWin

func partTwo(input: string): string =
    $input.parseRaceRecords(`singleRecord`).multiplyWaysToWin

const day* = (partOne: partOne, partTwo: partTwo)
