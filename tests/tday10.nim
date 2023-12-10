import mtest

testDay 10:
    withInput """
        -L|F7
        7S-7|
        L|7||
        -L-J|
        L|-JF
    """:
        expectPartOne "4"

    withInput """
        7-F7-
        .FJ|7
        SJLL7
        |F--J
        LJ.LJ
    """:
        expectPartOne "8"
