import mtest

testDay(7):
    withInput("""
        32T3K 765
        T55J5 684
        KK677 28
        KTJJT 220
        QQQJA 483
    """):
        expectPartOne("6440")
        expectPartTwo("5905")
