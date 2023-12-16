import mtest

testDay 16:
    withInput """
        .|...\....
        |.-.\.....
        .....|-...
        ........|.
        ..........
        .........\
        ..../.\\..
        .-.-/..|..
        .|....-|.\
        ..//.|....
    """:
        expectPartOne "46"
        expectPartTwo "51"
