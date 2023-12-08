import std/[algorithm, math, sequtils, strutils, tables]

type Game = tuple[hand: string, bid: int]

const cardMapping: Table[char, char] = {'T': 'A', 'J': 'B', 'Q': 'C', 'K': 'D', 'A': 'E'}.toTable

func parseGames(input: string): seq[Game] =
    for line in input.strip.splitLines:
        let parts = line.splitWhitespace
        result &= (hand: parts[0], bid: parts[1].parseInt)

func getRank(hand: string): (int, int) =
    let handType = hand.toCountTable.values.toSeq.mapIt(it * it).sum
    let handValue = hand.mapIt(cardMapping.getOrDefault(it, it)).join("").parseHexInt

    (handType, handValue)

func totalWinnings(games: seq[Game]): int =
    let sorted = games.sortedByIt(it.hand.getRank)

    for i, (_, bid) in sorted:
        result += bid * (i + 1)

func partOne(input: string): string =
    $input.parseGames.totalWinnings

func partTwo(input: string): string =
    "TODO"

const day* = (partOne: partOne, partTwo: partTwo)
