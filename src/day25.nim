import std/[algorithm, math, sequtils, strutils, tables]

type Components = OrderedTable[string, seq[string]]

func parseComponents(input: string): Components =
    for line in input.strip.splitLines:
        let parts = line.split(": ")
        let c1 = parts[0].strip

        for c2 in parts[1].strip.splitWhitespace:
            result[c1] = result.getOrDefault(c1, @[]) & c2
            result[c2] = result.getOrDefault(c2, @[]) & c1

func partOne(input: string): string =
    let components = input.parseComponents

    var keys = components.keys.toSeq
    while keys.mapIt(components[it].filterIt(it notin keys).len).sum != 3:
        keys = keys.sortedByIt(components[it].filterIt(it notin keys).len)[0..^2]

    $(keys.len * components.keys.toSeq.filterIt(it notin keys).len)

func partTwo(input: string): string = "N/A"

const day* = (partOne, partTwo)
