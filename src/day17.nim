import std/[heapqueue, options, sequtils, sets, strutils]

type
    Grid = seq[seq[uint]]
    Point = tuple[x: int, y: int]
    Direction = tuple[dx: int, dy: int]
    State = tuple[heatLoss: uint, point: Point, direction: Direction, steps: uint]

func turn(direction: Direction): seq[Direction] =
    let inverted = (direction.dx * -1, direction.dy * -1)
    @[(0, -1), (0, 1), (-1, 0), (1, 0)].filterIt(it notin [direction, inverted])

func next(point: Point, direction: Direction): Point =
    (x: point.x + direction.dx, y: point.y + direction.dy)

func parseGrid(input: string): Grid =
    input.strip.splitLines.mapIt(it.mapIt($it).map(`parseUInt`))

func contains(grid: Grid, point: Point): bool =
    point.y >= 0 and point.y <= grid.high and
    point.x >= 0 and point.x <= grid[point.y].high

func nextStates(grid: Grid, current: State): seq[State] =
    if current.steps < 3:
        let nextPoint = current.point.next(current.direction)

        if nextPoint in grid:
            let nextHeatLoss = current.heatLoss + grid[nextPoint.y][nextPoint.x]
            let nextSteps = current.steps + 1
            result &= (nextHeatLoss, nextPoint, current.direction, nextSteps)

    for turned in current.direction.turn:
        let nextPoint = current.point.next(turned)

        if nextPoint in grid:
            let nextHeatLoss = current.heatLoss + grid[nextPoint.y][nextPoint.x]
            let nextSteps = 1'u
            result &= (nextHeatLoss, nextPoint, turned, nextSteps)

func minHeatLoss(grid: Grid, startPoint: Point, endPoint: Point): uint =
    var seen: HashSet[tuple[point: Point, direction: Direction, steps: uint]]
    var queue: HeapQueue[State]

    queue.push((heatLoss: 0'u, point: startPoint, direction: (dx: 1, dy: 0), steps: 0'u))

    while queue.len > 0:
        let state = queue.pop

        if state.point == endPoint:
            return state.heatLoss

        if (state.point, state.direction, state.steps) in seen:
            continue

        seen.incl((state.point, state.direction, state.steps))

        for newState in grid.nextStates(state):
            queue.push(newState)

func partOne(input: string): string =
    let grid = input.parseGrid

    let startPoint = (x: 0, y: 0)
    let endPoint = (x: grid[0].high, y: grid.high)

    $grid.minHeatLoss(startPoint, endPoint)

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
