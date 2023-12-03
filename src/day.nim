import std/[sugar, tables]

type Day = object
    partOne*: string -> string
    partTwo*: string -> string

import day01, day02

const days* = {
      1: Day(partOne: day01.partOne, partTwo: day01.partTwo),
      2: Day(partOne: day02.partOne, partTwo: day02.partTwo),
}.toTable
