import std/[math, nre, sequtils, strutils, tables]

type
    Part = object
        cool: uint
        musical: uint
        aerodynamic: uint
        shiny: uint

    PartRange = tuple[min: Part, max: Part]

    Rule = object
        category: char
        condition: char
        value: uint
        destination: string

    Workflow = object
        rules: seq[Rule]
        otherwise: string

    Workflows = Table[string, Workflow]

func parseRuleset(ruleset: string): seq[Rule] =
    let ruleRegex = """(?<category>x|m|a|s)(?<condition>[<=>])(?<value>\d+):(?<destination>[a-zAR]+)""".re

    for rule in ruleset.split(','):
        let matches = rule.match(ruleRegex)

        if matches.isNone:
            raise newException(ValueError, "Invalid rule: " & rule)

        result &= Rule(
            category: matches.get.captures["category"][0],
            condition: matches.get.captures["condition"][0],
            value: matches.get.captures["value"].parseUInt,
            destination: matches.get.captures["destination"]
        )

func parseSystem(input: string): tuple[workflows: Workflows, parts: seq[Part]] =
    let workflowRegex = """(?<id>[a-z]+){(?<rules>(.*?)),(?<otherwise>[a-zAR]+)}""".re
    let partRegex = """{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}""".re

    let split = input.strip.split("\n\n")

    let workflows = split[0]
    for line in workflows.splitLines:
        let matches = line.match(workflowRegex)

        if matches.isNone:
            raise newException(ValueError, "Invalid workflow: " & line)

        result.workflows[matches.get.captures["id"]] = Workflow(
            rules: matches.get.captures["rules"].parseRuleset,
            otherwise: matches.get.captures["otherwise"]
        )

    let parts = split[1]
    for line in parts.splitLines:
        let matches = line.match(partRegex)

        if matches.isNone:
            raise newException(ValueError, "Invalid part: " & line)

        result.parts &= Part(
            cool: matches.get.captures["x"].parseUInt,
            musical: matches.get.captures["m"].parseUInt,
            aerodynamic: matches.get.captures["a"].parseUInt,
            shiny: matches.get.captures["s"].parseUInt
        )

func `[]`(part: Part, category: char): uint =
    case category:
        of 'x': part.cool
        of 'm': part.musical
        of 'a': part.aerodynamic
        of 's': part.shiny
        else: raise newException(IndexDefect, "Invalid category: " & $category)

func replaced(part: Part, category: char, value: uint): Part =
    result = part
    case category:
        of 'x': result.cool = value
        of 'm': result.musical = value
        of 'a': result.aerodynamic = value
        of 's': result.shiny = value
        else: raise newException(IndexDefect, "Invalid category: " & $category)

func rating(part: Part): uint =
    part.cool + part.musical + part.aerodynamic + part.shiny

func combinations(range: PartRange): uint =
    result = [
        range.max.cool - range.min.cool + 1,
        range.max.musical - range.min.musical + 1,
        range.max.aerodynamic - range.min.aerodynamic + 1,
        range.max.shiny - range.min.shiny + 1
    ].prod

func accepts(workflows: Workflows, part: Part): bool =
    var current = "in"

    while current notin ["A", "R"]:
        let matching = workflows[current].rules.filterIt:
            case it.condition:
                of '<': part[it.category] < it.value
                of '=': part[it.category] == it.value
                of '>': part[it.category] > it.value
                else: false

        if matching.len == 0:
            current = workflows[current].otherwise
        else:
            current = matching[0].destination

    current == "A"

func accepted(workflows: Workflows, range: PartRange): seq[PartRange] =
    func loop(range: PartRange, current: string): seq[PartRange] =
        if current == "R": return @[]
        if current == "A": return @[range]

        var (min, max) = range

        for rule in workflows[current].rules:
            var matched = (min: min[rule.category], max: max[rule.category])
            var unmatched = (min: min[rule.category], max: max[rule.category])

            if rule.condition == '<':
                matched.max = min(matched.max, rule.value - 1)
                unmatched.min = max(unmatched.min, rule.value)

            if rule.condition == '>':
                matched.min = max(matched.min, rule.value + 1)
                unmatched.max = min(unmatched.max, rule.value)

            if matched.min <= matched.max:
                result &= loop(
                    range = (
                        min: min.replaced(rule.category, matched.min),
                        max: max.replaced(rule.category, matched.max)
                    ),
                    current = rule.destination
                )

            if unmatched.min <= unmatched.max:
                min = min.replaced(rule.category, unmatched.min)
                max = max.replaced(rule.category, unmatched.max)

        result &= loop((min, max), current = workflows[current].otherwise)

    loop(range, current = "in")

func partOne(input: string): string =
    let (workflows, parts) = input.parseSystem
    $parts.filterIt(workflows.accepts(it)).map(`rating`).sum

func partTwo(input: string): string =
    const range: PartRange = (
        min: Part(cool: 1, musical: 1, aerodynamic: 1, shiny: 1),
        max: Part(cool: 4000, musical: 4000, aerodynamic: 4000, shiny: 4000)
    )

    let (workflows, _) = input.parseSystem
    $workflows.accepted(range).map(`combinations`).sum

const day* = (partOne, partTwo)
