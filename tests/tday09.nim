import mtest

testDay 9:
    withInput """
        0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
    """:
        expectPartOne "114"
        expectPartTwo "2"
