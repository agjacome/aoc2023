import mtest

testDay 20:
    withInput """
        broadcaster -> a, b, c
        %a -> b
        %b -> c
        %c -> inv
        &inv -> a
    """:
        expectPartOne "32000000"

    withInput """
        broadcaster -> a
        %a -> inv, con
        &inv -> b
        %b -> con
        &con -> output
    """:
        expectPartOne "11687500"
