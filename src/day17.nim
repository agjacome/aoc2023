import std/[heapqueue, sequtils, sets, strutils, sugar]

type
    Grid = seq[seq[uint]]
    Point = tuple[x: int, y: int]
    Direction = tuple[dx: int, dy: int]
    State = object
        heatLoss: uint
        point: Point
        direction: Direction
        steps: uint

func `<`(a: State, b: State): bool =
    a.heatLoss < b.heatLoss

func turn(direction: Direction): seq[Direction] =
    let opposite = (direction.dx * -1, direction.dy * -1)
    @[(0, -1), (0, 1), (-1, 0), (1, 0)].filterIt(it notin [direction, opposite])

func next(point: Point, direction: Direction): Point =
    (x: point.x + direction.dx, y: point.y + direction.dy)

func parseGrid(input: string): Grid =
    input.strip.splitLines.mapIt(it.mapIt($it).map(`parseUInt`))

func contains(grid: Grid, point: Point): bool =
    point.y >= 0 and point.y <= grid.high and
    point.x >= 0 and point.x <= grid[point.y].high

iterator continuing(current: State, grid: Grid): State =
    let nextPoint = current.point.next(current.direction)

    if nextPoint in grid:
        yield State(
            heatLoss: current.heatLoss + grid[nextPoint.y][nextPoint.x],
            point: nextPoint,
            direction: current.direction,
            steps: current.steps + 1
        )

iterator turning(current: State, grid: Grid): State =
    for turned in current.direction.turn:
        let nextPoint = current.point.next(turned)

        if nextPoint in grid:
            yield State(
               heatLoss: current.heatLoss + grid[nextPoint.y][nextPoint.x],
               point: nextPoint,
               direction: turned,
               steps: 1'u
            )

func minHeatLoss(
    grid: Grid,
    startPoint: Point,
    isEnd: (State {.noSideEffect.} -> bool),
    canContinue: (State {.noSideEffect.} -> bool),
    canTurn: (State {.noSideEffect.} -> bool)
): uint =
    var seen: HashSet[(Point, Direction, uint)]
    var queue: HeapQueue[State]

    queue.push(State(
        heatLoss: 0'u,
        point: startPoint,
        direction: (dx: 1, dy: 0),
        steps: 0'u
    ))

    while queue.len > 0:
        let current = queue.pop

        if current.isEnd:
            return current.heatLoss

        if (current.point, current.direction, current.steps) in seen:
            continue

        seen.incl((current.point, current.direction, current.steps))

        if current.canContinue:
            for next in current.continuing(grid): queue.push(next)
        if current.canTurn:
            for next in current.turning(grid): queue.push(next)

func partOne(input: string): string =
    let grid = input.parseGrid

    let startPoint = (x: 0, y: 0)
    let endPoint = (x: grid[0].high, y: grid.high)

    $grid.minHeatLoss(
        startPoint = startPoint,
        isEnd = (s: State) => s.point == endPoint,
        canContinue = (s: State) => s.steps < 3,
        canTurn = (_: State) => true
    )

func partTwo(input: string): string =
    let grid = input.parseGrid

    let startPoint = (x: 0, y: 0)
    let endPoint = (x: grid[0].high, y: grid.high)

    $grid.minHeatLoss(
        startPoint = startPoint,
        isEnd = (s: State) => s.point == endPoint and s.steps >= 4,
        canContinue = (s: State) => s.steps < 10,
        canTurn = (s: State) => s.steps >= 4
    )

const day* = (partOne, partTwo)
