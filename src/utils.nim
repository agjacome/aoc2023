import std/[sequtils, sugar]

func transpose*[A](xs: seq[seq[A]]): seq[seq[A]] =
    (0 .. xs[0].high).toSeq.map(
        row => (0 .. xs.high).toSeq.map(
            col => xs[col][row]
        )
    )

func split*[A](xs: seq[A], pred: (A {.noSideEffect.} -> bool)): seq[seq[A]] =
    var current: seq[A] = @[]

    for x in xs:
        if pred(x):
            result &= current
            current = @[]
        else:
            current &= x

    result &= current

func split*[A](xs: seq[A], a: A): seq[seq[A]] =
    split(xs, (x: A) => x == a)

func join*[A](xs: seq[seq[A]], a: A): seq[A] =
    for x in xs[0 ..< xs.high]:
        result &= (x & a)

    result &= xs[xs.high]
