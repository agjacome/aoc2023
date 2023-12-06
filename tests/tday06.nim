import mtest

testDay(6):
    withInput("""
        Time:      7  15   30
        Distance:  9  40  200
    """):
        expectPartOne("288")
        expectPartTwo("71503")
