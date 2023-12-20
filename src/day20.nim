import std/[deques, math, sequtils, strutils, sugar, tables]

type
    Pulse = enum Low, High
    Input = tuple[src: string, value: Pulse]
    Output = tuple[dst: string, value: Pulse]
    State = tuple[src: string, dst: string, value: Pulse]

    Module = ref object of RootObj
        name: string
        destinations: seq[string]
    FlipFlop = ref object of Module
        state: bool
    Conjunction = ref object of Module
        inputs: Table[string, Pulse]
    Broadcast = ref object of Module

    Network = Table[string, Module]

method receive(self: Module, input: Input): seq[Output] {.base.} = @[]
method connectTo(self: Module, name: string): void {.base.} = discard

func newFlipFlop(name: string, destinations: seq[string]): FlipFlop =
    result = new(FlipFlop)
    result.name = name
    result.destinations = destinations
    result.state = false

method receive(self: FlipFlop, input: Input): seq[Output] =
    if input.value == Pulse.High:
        return @[]

    let outValue = if self.state: Pulse.Low else: Pulse.High
    self.state = not self.state

    return self.destinations.mapIt((dst: it, value: outValue))

func newConjunction(name: string, destinations: seq[string]): Conjunction =
    result = new(Conjunction)
    result.name = name
    result.destinations = destinations
    result.inputs = initTable[string, Pulse]()

method receive(self: Conjunction, input: Input): seq[Output] =
    self.inputs[input.src] = input.value

    let allHigh = self.inputs.values.toSeq.allIt(it == Pulse.High)
    let outValue = if allHigh: Pulse.Low else: Pulse.High

    return self.destinations.mapIt((dst: it, value: outValue))

method connectTo(self: Conjunction, name: string): void =
    self.inputs[name] = Pulse.Low

func newBroadcast(name: string, destinations: seq[string]): Broadcast =
    result = new(Broadcast)
    result.name = name
    result.destinations = destinations

method receive(self: Broadcast, input: Input): seq[Output] =
    return self.destinations.mapIt((dst: it, value: input.value))

func parseNetwork(input: string): Network =
    for line in input.strip.splitLines:
        let parts = line.split(" -> ")

        let name = parts[0]
        let destinations = parts[1].split(", ")

        if name == "broadcaster":
            result[name] = newBroadcast(name, destinations)
        elif name[0] == '%':
            let name = name[1..^1]
            result[name] = newFlipFlop(name, destinations)
        elif name[0] == '&':
            let name = name[1..^1]
            result[name] = newConjunction(name, destinations)
        else:
            raise newException(ValueError, "Unknown module type " & name)

    for name, module in result:
        for dst in module.destinations:
            if dst in result:
                result[dst].connectTo(name)

func pushButton(
    network: var Network,
    onEach: (State {.noSideEffect.} -> void) = func(state: State): void = discard
): tuple[low: int, high: int] =
    var queue: Deque[State]

    queue.addLast((
        src: "button",
        dst: "broadcaster",
        value: Pulse.Low
    ))

    while queue.len > 0:
        let current = queue.popFirst

        current.onEach()

        result.low += (if current.value == Pulse.Low: 1 else: 0)
        result.high += (if current.value == Pulse.High: 1 else: 0)

        if current.dst notin network:
            continue

        let input = (src: current.src, value: current.value)
        let outputs = network[current.dst].receive(input)

        for output in outputs:
            queue.addLast((
                src: current.dst,
                dst: output.dst,
                value: output.value
            ))

func findParents(network: Network, needle: string): seq[string] =
    for name, module in network:
        if needle in module.destinations:
            result &= name

func partOne(input: string): string =
    var network = input.parseNetwork
    var total = (low: 0, high: 0)

    for i in 1 .. 1000:
        let count = network.pushButton()
        total.low += count.low
        total.high += count.high

    $(total.low * total.high)

func partTwo(input: string): string =
    var network = input.parseNetwork

    # "rx" parent is always a conjunction, its parents have to all be High for
    # a Low pulse to be sent to "rx"
    let rxGrandParents = collect:
        for parent in network.findParents("rx"):
            for grandParent in network.findParents(parent):
                grandParent

    var indices: Table[string, int]

    var index = 0
    while indices.len < rxGrandParents.len:
        index += 1
        discard network.pushButton(func (state: State): void =
            if state.src notin rxGrandParents: return
            if state.src in indices: return
            if state.value != Pulse.High: return

            indices[state.src] = index
        )

    $indices.values.toSeq.lcm

const day* = (partOne, partTwo)
