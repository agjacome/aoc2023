import std/[sequtils, strutils]

type
    Mapping =
        tuple[destination: uint, source: uint, length: uint]
    Almanac = object
        seeds: seq[uint]
        maps: seq[seq[Mapping]]

func parseAlmanac(input: string): Almanac =
    let lineBlocks = input.strip.split("\n\n")

    for seed in lineBlocks[0].split(": ")[1].splitWhitespace:
        result.seeds &= seed.parseUInt

    for lineBlock in lineBlocks[1..^1]:
        var blockMap: seq[Mapping] = @[]

        for line in lineBlock.split(":\n")[1].splitLines:
            let map = line.splitWhitespace.map(`parseUInt`)
            if map.len == 3:
                blockMap &= (destination: map[0], source: map[1], length: map[2])

        result.maps &= blockMap

func mapSeeds(seeds: seq[uint], map: seq[Mapping]): seq[uint] =
    for seed in seeds:
        let match = map.filterIt(it.source <= seed and seed < it.source + it.length)

        if match.len > 0:
            result &= seed - match[0].source + match[0].destination
        else:
            result &= seed

func partOne*(input: string): string =
    let almanac = input.parseAlmanac

    let locations = almanac.maps.foldl(
        operation = mapSeeds(a, b),
        first = almanac.seeds
    )

    $locations.min

func partTwo*(input: string): string =
    "TODO"
