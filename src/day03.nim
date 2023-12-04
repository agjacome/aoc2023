import std/[sequtils, sets, strutils, sugar]

type
    Engine = seq[seq[char]]
    Position = tuple[row: int, col: int]

func getAdjacentPositions(row, col: int): seq[Position] =
    @[
        (row: row - 1, col: col - 1),
        (row: row - 1, col: col),
        (row: row - 1, col: col + 1),
        (row: row, col: col - 1),
        (row: row, col: col + 1),
        (row: row + 1, col: col - 1),
        (row: row + 1, col: col),
        (row: row + 1, col: col + 1),
    ]

func getAdjacentCells(engine: Engine, row, col: int): seq[char] =
    getAdjacentPositions(row, col)
        .filterIt(it.row >= 0 and it.row < engine.len and it.col >= 0 and it.col < engine[row].len)
        .mapIt(engine[it.row][it.col])

func isPartNumber(engine: Engine, row, startCol, endCol: int): bool =
    func isSymbol(char: char): bool =
        char != '.' and not char.isDigit

    (startCol .. endCol).anyIt(engine.getAdjacentCells(row, it).any(`isSymbol`))

func parseEngine(input: string): Engine =
    input.strip.splitLines.mapIt(it.items.toSeq)

func partOne*(input: string): string =
    func sumPartNumbers(engine: Engine): uint =
        result = 0'u
        for row in 0 ..< engine.len:
            var number = ""

            for col in 0 .. engine[row].len:
                if col < engine[row].len and engine[row][col].isDigit:
                    number &= engine[row][col]
                    continue

                if number.len > 0 and engine.isPartNumber(row, col - number.len, col - 1):
                    result += number.parseUInt

                number = ""

    $input.parseEngine.sumPartNumbers

# TODO: ugly, refactor to use same approach in p1 and extract common code
func partTwo*(input: string): string =
    let engine = input.parseEngine

    func getFirstDigitPosition(p: Position): Position =
        var col = p.col
        while col > 0 and engine[p.row][col - 1].isDigit:
            col -= 1

        (row: p.row, col: col)

    var gears = initHashSet[(Position, Position)]()

    for row in 0 ..< engine.len:
        for col in 0 ..< engine[row].len:
            if engine[row][col] != '*':
                continue

            let partNumbers = getAdjacentPositions(row, col)
                .filterIt(it.row >= 0 and it.row < engine.len)
                .filterIt(it.col >= 0 and it.col < engine[row].len)
                .filterIt(engine[it.row][it.col].isDigit)
                .map(`getFirstDigitPosition`)
                .deduplicate

            if (partNumbers.len == 2):
                gears.incl((partNumbers[0], partNumbers[1]))

    var sum = 0'u
    for (part1, part2) in gears:
        var number1 = ""
        var number2 = ""

        for col in part1.col ..< engine[part1.row].len:
            if not engine[part1.row][col].isDigit:
                break

            number1 &= engine[part1.row][col]

        for col in part2.col ..< engine[part2.row].len:
            if not engine[part2.row][col].isDigit:
                break

            number2 &= engine[part2.row][col]

        sum += number1.parseUInt * number2.parseUInt

    $sum

