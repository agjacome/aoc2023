import std/[math, sequtils, sets, strutils, sugar]

type
    Engine = seq[seq[char]]
    Position = tuple[row: int, col: int]

func getAdjacents(pos: Position): seq[Position] =
    @[
        (row: pos.row - 1, col: pos.col - 1),
        (row: pos.row - 1, col: pos.col),
        (row: pos.row - 1, col: pos.col + 1),
        (row: pos.row, col: pos.col - 1),
        (row: pos.row, col: pos.col + 1),
        (row: pos.row + 1, col: pos.col - 1),
        (row: pos.row + 1, col: pos.col),
        (row: pos.row + 1, col: pos.col + 1),
    ]

func getFirstDigit(engine: Engine, pos: Position): Position =
    var col = pos.col
    while col > 0 and engine[pos.row][col - 1].isDigit:
        col -= 1

    (row: pos.row, col: col)

func getAdjacentNumbersPositions(engine: Engine, pos: Position): HashSet[Position] =
    pos.getAdjacents
        .filterIt(it.row >= 0 and it.row < engine.len)
        .filterIt(it.col >= 0 and it.col < engine[pos.row].len)
        .filterIt(engine[it.row][it.col].isDigit)
        .mapIt(engine.getFirstDigit(it))
        .toHashSet

func parseNumberAt(engine: Engine, pos: Position): uint =
    var number = ""

    for col in pos.col ..< engine[pos.row].len:
        if not engine[pos.row][col].isDigit:
            break

        number &= engine[pos.row][col]

    number.parseUInt

iterator partNumbersMatching(
    engine: Engine,
    predicate: (char {.noSideEffect.} -> bool)
): HashSet[Position] =
    for row in 0 ..< engine.len:
        for col in 0 ..< engine[row].len:
            if not engine[row][col].predicate:
                continue

            let position = (row: row, col: col)
            yield engine.getAdjacentNumbersPositions(position)

func parseEngine(input: string): Engine =
    input.strip.splitLines.mapIt(it.items.toSeq)

func partOne*(input: string): string =
    func isSymbol(c: char): bool = not (c == '.' or c.isDigit)

    let engine = input.parseEngine
    var parts = initHashSet[Position]()

    for partNumbers in engine.partNumbersMatching(`isSymbol`):
        parts = parts + partNumbers

    $parts.toSeq.mapIt(engine.parseNumberAt(it)).sum

func partTwo*(input: string): string =
    func isGear(c: char): bool = c == '*'

    let engine = input.parseEngine
    var gears = initHashSet[(Position, Position)]()

    for partNumbers in engine.partNumbersMatching(`isGear`):
        var partNumbers = partNumbers
        if (partNumbers.len == 2):
            let fst = partNumbers.pop
            let snd = partNumbers.pop
            gears.incl((fst, snd))

    $gears.toSeq.mapIt(engine.parseNumberAt(it[0]) * engine.parseNumberAt(it[1])).sum
