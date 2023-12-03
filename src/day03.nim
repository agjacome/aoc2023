import std/[sequtils, strutils]

type Engine = seq[seq[char]]

func getAdjacentPositions(row, col: int): seq[tuple[row: int, col: int]] =
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

func partTwo*(input: string): string =
    "TODO"
