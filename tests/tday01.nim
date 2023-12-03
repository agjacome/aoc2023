import mtest

testDay(1):
    withInput("""
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
    """):
        expectPartOne("142")

    withInput("""
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
    """):
        expectPartTwo("281")
