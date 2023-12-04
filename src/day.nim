import std/[sugar, tables]

type Day = object
    partOne*: string -> string
    partTwo*: string -> string

import day01, day02, day03, day04

const days* = {
      1: Day(partOne: day01.partOne, partTwo: day01.partTwo),
      2: Day(partOne: day02.partOne, partTwo: day02.partTwo),
      3: Day(partOne: day03.partOne, partTwo: day03.partTwo),
      4: Day(partOne: day04.partOne, partTwo: day04.partTwo),
}.toTable
