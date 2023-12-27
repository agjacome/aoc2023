import std/[options, tables]

import day01, day02, day03, day04, day05
import day06, day07, day08, day09, day10
import day11, day12, day13, day14, day15
import day16, day17, day18, day19, day20
import day21, day22, day23, day24

type Day = concept d
    d.partOne(string) is string
    d.partTwo(string) is string

const days*: Table[int, Day] = {
     1: day01.day,
     2: day02.day,
     3: day03.day,
     4: day04.day,
     5: day05.day,
     6: day06.day,
     7: day07.day,
     8: day08.day,
     9: day09.day,
    10: day10.day,
    11: day11.day,
    12: day12.day,
    13: day13.day,
    14: day14.day,
    15: day15.day,
    16: day16.day,
    17: day17.day,
    18: day18.day,
    19: day19.day,
    20: day20.day,
    21: day21.day,
    22: day22.day,
    23: day23.day,
    24: day24.day,
}.toTable

func solve*(dayNumber: int, input: string): Option[(string, string)] =
    if dayNumber notin days:
        return (string, string).none

    let day = days[dayNumber]
    (day.partOne(input), day.partTwo(input)).some

