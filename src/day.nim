import std/[sugar, tables]

type Day = object
    partOne*: string -> string
    partTwo*: string -> string

import day01, day02, day03, day04, day05, day06

const days* = {
      1: Day(partOne: day01.partOne, partTwo: day01.partTwo),
      2: Day(partOne: day02.partOne, partTwo: day02.partTwo),
      3: Day(partOne: day03.partOne, partTwo: day03.partTwo),
      4: Day(partOne: day04.partOne, partTwo: day04.partTwo),
      5: Day(partOne: day05.partOne, partTwo: day05.partTwo),
      6: Day(partOne: day06.partOne, partTwo: day06.partTwo),
}.toTable
