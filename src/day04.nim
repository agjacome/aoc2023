import std/[math, nre, sequtils, strutils, tables]

type
    Card = object
        id: uint
        winning: seq[uint]
        owned: seq[uint]

func parseNumbers(input: string): seq[uint] =
    input.split(" ").filterIt(not it.isEmptyOrWhitespace).map(`parseUInt`)

func parseCards(input: string): seq[Card] =
    for match in input.findIter("""Card +(\d+): ([\d ]+) \| ([\d ]+)""".re):
        let card = Card(
            id: match.captures[0].parseUInt,
            winning: match.captures[1].parseNumbers,
            owned: match.captures[2].parseNumbers
        )

        result &= card

func partOne*(input: string): string =
    var sum = 0

    for card in parseCards(input):
        let matches = card.owned.filterIt(it in card.winning)

        if matches.len > 0:
            sum += 2 ^ (matches.len - 1)

    $sum

func partTwo*(input: string): string =
    let cards = parseCards(input)

    var cardCount = toCountTable(cards.mapIt(it.id))

    for card in cards:
        let times = cardCount[card.id]
        let matches = card.owned.filterIt(it in card.winning)

        for match in 1 .. matches.len.uint:
            cardCount.inc(card.id + match, times)

    $cardCount.values.toSeq.sum

