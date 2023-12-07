import std/[sequtils, strutils]

type
    Range =
        tuple[first: uint, last: uint]
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

func mapSeeds(seeds: seq[uint], maps: seq[Mapping]): seq[uint] =
    for seed in seeds:
        let matches = maps.filterIt(it.source <= seed and seed < it.source + it.length)

        if matches.len > 0:
            result &= seed - matches[0].source + matches[0].destination
        else:
            result &= seed

func findOverlap(seeds: Range, map: Mapping): Range =
    let first = seeds.first.max(map.source)
    let last = seeds.last.min(map.source + map.length - 1)

    if first < last:
        (first: first, last: last)
    else:
        (first: 0, last: 0)

func mapSeedRanges(seedRanges: seq[Range], maps: seq[Mapping]): seq[Range] =
    var currentSeeds = seedRanges

    while currentSeeds.len > 0:
        let seed = currentSeeds.pop

        let overlaps = maps
            .mapIt((map: it, overlap: findOverlap(seed, it)))
            .filterIt(it.overlap.last > it.overlap.first)

        if overlaps.len == 0:
            result &= seed
            continue

        let (map, overlap) = overlaps[0]

        if overlap.first > seed.first:
            currentSeeds &= (first: seed.first, last: overlap.first - 1)

        if seed.last > overlap.last:
            currentSeeds &= (first: overlap.last + 1, last: seed.last)

        result &= (
            first: overlap.first + map.destination - map.source,
            last: overlap.last + map.destination - map.source
        )

func partOne(input: string): string =
    let almanac = input.parseAlmanac

    let locations = almanac.maps.foldl(
        operation = mapSeeds(a, b),
        first = almanac.seeds
    )

    $locations.min

func partTwo(input: string): string =
    let almanac = input.parseAlmanac

    var seedRanges: seq[Range] = @[]

    for i in countup(0, almanac.seeds.len - 1, 2):
        let first = almanac.seeds[i]
        let last = almanac.seeds[i] + almanac.seeds[i + 1] - 1
        seedRanges &= (first: first, last: last)

    let locations = almanac.maps.foldl(
        operation = mapSeedRanges(a, b),
        first = seedRanges
    )

    $locations.min.first

const day* = (partOne: partOne, partTwo: partTwo)
