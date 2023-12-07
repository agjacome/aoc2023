import std/[algorithm, sequtils, strutils, tables]

type
    Game = tuple[hand: string, bid: int]
    HandType = enum
        FiveOfAKind = 1
        FourOfAKind
        FullHouse
        ThreeOfAKind
        TwoPair
        OnePair
        HighCard

const cardRank: Table[char, char] = {
    'A': '1',
    'K': '2',
    'Q': '3',
    'J': '4',
    'T': '5',
    '9': '6',
    '8': '7',
    '7': '8',
    '6': '9',
    '5': 'A',
    '4': 'B',
    '3': 'C',
    '2': 'D',
}.toTable

func parseGames(input: string): seq[Game] =
    for line in input.strip.splitLines:
        let parts = line.splitWhitespace
        result &= (hand: parts[0], bid: parts[1].parseInt)

func getType(hand: string): HandType =
    let counts = hand.toCountTable

    case counts.len:
        of 1: return FiveOfAKind
        of 2: return if counts.largest[1] == 4: FourOfAKind else: FullHouse
        of 3: return if counts.largest[1] == 3: ThreeOfAKind else: TwoPair
        of 4: return OnePair
        else: return HighCard

func getValue(hand: string): string =
    hand.mapIt(cardRank[it]).join("")

func byHandRank(a, b: Game): int =
    let x = (a.hand.getType, a.hand.getValue)
    let y = (b.hand.getType, b.hand.getValue)

    x.cmp(y)

func totalWinnings(games: seq[Game]): int =
    for i, (hand, bid) in games.sorted(`byHandRank`, order = SortOrder.Descending):
        result += bid * (i + 1)

func partOne(input: string): string =
    $input.parseGames.totalWinnings

func partTwo(input: string): string =
    "TODO"

const day* = (partOne: partOne, partTwo: partTwo)
