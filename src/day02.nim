import std/[math, nre, sequtils, strutils]

type
    CubeSet = tuple[red: uint, green: uint, blue: uint]
    GameRecord = tuple[id: uint, games: seq[CubeSet]]

func parseCubeSet(cubeSet: string): CubeSet =
    for match in cubeSet.findIter("""(\d+) (red|green|blue)""".re):
        case match.captures[1]
            of "red": result.red = match.captures[0].parseUInt
            of "green": result.green = match.captures[0].parseUInt
            of "blue": result.blue = match.captures[0].parseUInt

func parseGamesRecord(input: string): seq[GameRecord] =
    for match in input.findIter("""Game (\d+): (.*)""".re):
        let id = match.captures[0].parseUInt
        let games = match.captures[1].split("; ").map(`parseCubeSet`)
        result &= (id: id, games: games)

func partOne*(input: string): string =
    const limits: CubeSet = (red: 12, green: 13, blue: 14)

    func isGamePossible(game: seq[CubeSet]): bool =
        game.allIt(it.red <= limits.red and it.green <= limits.green and it.blue <= limits.blue)

    let sum = parseGamesRecord(input)
        .filterIt(isGamePossible(it.games))
        .mapIt(it.id)
        .sum

    $sum

func partTwo*(input: string): string =
    func getMinPossibleSet(game: seq[CubeSet]): CubeSet =
        for cube in game:
            result.red = max(result.red, cube.red)
            result.green = max(result.green, cube.green)
            result.blue = max(result.blue, cube.blue)

    let power = parseGamesRecord(input)
        .mapIt(getMinPossibleSet(it.games))
        .mapIt(it.red * it.green * it.blue)
        .sum

    $power
