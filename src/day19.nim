import std/[math, nre, sequtils, strutils, sugar, tables]

type
    Part = Table[char, uint]

    Rule = object
        category: char
        condition: char
        value: uint
        destination: string

    Workflow = object
        rules: seq[Rule]
        otherwise: string

    System = object
        parts: seq[Part]
        workflows: Table[string, Workflow]

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

func parseSystem(input: string): System =
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

        result.parts &= {
            'x': matches.get.captures["x"].parseUInt,
            'm': matches.get.captures["m"].parseUInt,
            'a': matches.get.captures["a"].parseUInt,
            's': matches.get.captures["s"].parseUInt
        }.toTable

func rating(part: Part): uint =
    part.values.toSeq.sum

func matches(rule: Rule, part: Part): bool =
    case rule.condition:
        of '<': part[rule.category] < rule.value
        of '=': part[rule.category] == rule.value
        of '>': part[rule.category] > rule.value
        else: false

func process(system: System, part: Part): uint =
    var current = "in"

    while current notin ["A", "R"]:
        let matching = system.workflows[current].rules.filterIt(it.matches(part))

        if matching.len == 0:
            current = system.workflows[current].otherwise
        else:
            current = matching[0].destination

    if current == "A":
        part.rating
    else:
        0'u

func partOne(input: string): string =
    let system = input.parseSystem

    $system.parts.map(part => system.process(part)).sum

func partTwo(input: string): string = "TODO"

const day* = (partOne, partTwo)
