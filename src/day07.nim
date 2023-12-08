import std/[algorithm, math, sequtils, strutils, tables]

type
    Game = tuple[hand: string, bid: int]
    HandRank = (int, int)

const basicMapping: Table[char, char] = {'T': 'A', 'J': 'B', 'Q': 'C', 'K': 'D', 'A': 'E'}.toTable
const jokerMapping: Table[char, char] = {'J': '0', 'T': 'A', 'Q': 'B', 'K': 'C', 'A': 'D'}.toTable

const nonJokerCards = @['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']

func parseGames(input: string): seq[Game] =
    for line in input.strip.splitLines:
        let parts = line.splitWhitespace
        result &= (hand: parts[0], bid: parts[1].parseInt)

func getRank(
    handForType: string,
    handForValue: string,
    cardMapping: Table[char, char]
): HandRank =
    let handType = handForType.toCountTable.values.toSeq.mapIt(it * it).sum
    let handValue = handForValue.mapIt(cardMapping.getOrDefault(it, it)).join("").parseHexInt

    (handType, handValue)

func getBasicRank(hand: string): HandRank =
    getRank(hand, hand, basicMapping)

func getJokerRank(hand: string): HandRank =
    result = getRank(hand, hand, jokerMapping)

    var stack = @[hand]
    while stack.len > 0:
        let current = stack.pop

        let jokerIndex = current.find('J')

        if jokerIndex == -1:
            let newRank = getRank(current, hand, jokerMapping)
            result = max(result, newRank)
            continue

        for card in nonJokerCards:
            let replaced = current[0 ..< jokerIndex] & card & current[jokerIndex + 1 ..< current.len]
            stack &= replaced

func totalWins(games: seq[Game]): int =
    for i, (_, bid) in games:
        result += bid * (i + 1)

func partOne(input: string): string =
    let games = input.parseGames
    let sorted = games.sortedByIt(it.hand.getBasicRank)

    $sorted.totalWins

func partTwo(input: string): string =
    let games = input.parseGames
    let sorted = games.sortedByIt(it.hand.getJokerRank)

    $sorted.totalWins

const day* = (partOne: partOne, partTwo: partTwo)
