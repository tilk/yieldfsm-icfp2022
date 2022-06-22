module FSM.ICFP2022.Examples where

import FSM
import Clash.Prelude

-- Examples from the tutorial

-- 3.1

[fsm|count4_mealy :: HiddenClockResetEnable dom
                  => Signal dom (Unsigned 1)
                  -> Signal dom (Unsigned 2)
input i
var n = 0
forever:
    n = n + extend i
    yield n
|]

[fsm|count4_moore :: HiddenClockResetEnable dom
                  => Signal dom (Unsigned 1)
                  -> Signal dom (Unsigned 2)
input i
var n = 0
forever:
    let prev_n = n
    n = n + extend i
    yield prev_n
|]

[fsm|count4_moore_alt :: HiddenClockResetEnable dom
                      => Signal dom (Unsigned 1)
                      -> Signal dom (Unsigned 2)
input i
var n = 0
forever:
    let prev_i = i
    yield n
    n = n + extend prev_i
|]

[fsm|count4_moore_magic :: HiddenClockResetEnable dom
                        => Signal dom (Unsigned 1)
                        -> Signal dom (Unsigned 2)
input i
var n = 0
forever:
    yield n
    n = n + extend i'
|]

-- 3.2

[fsm|count4_mealy_if :: HiddenClockResetEnable dom
                     => Signal dom (Unsigned 1)
                     -> Signal dom (Unsigned 2)
input i
var n = 0
forever:
    if i == 1:
        n = n + 1
    yield n
|]

-- 3.3

[fsm|count4_mealy_desugared :: HiddenClockResetEnable dom
                            => Signal dom (Unsigned 1)
                            -> Signal dom (Unsigned 2)
input i
var n = 0
fun loop ():
    n = n + extend i
    yield n
    ret call loop ()
ret call loop ()
|]

[fsm|let_call_example :: HiddenClockResetEnable dom
                      => Signal dom Bool
                      -> Signal dom (Unsigned 2)
input i
fun count ():
    var n = 0
    while i:
        n = n + 1
        yield 0
    ret n
forever:
    let n = call count ()
    yield n
|]

-- 3.4

[fsm|output_example :: HiddenClockResetEnable dom
                    => Signal dom (Unsigned 1, Unsigned 1)
output a = 0
output b = 0
forever:
    yield<a> 1
    yield<a, b> (1, 1)
    yield
    output<b> 1
    yield
|]

-- 3.5

count4_ones_zeros :: HiddenClockResetEnable dom
                  => Signal dom (Unsigned 1)
                  -> Signal dom (Unsigned 2, Unsigned 2)
count4_ones_zeros i = bundle (count4_moore i, count4_moore ((1 -) <$> i))

-- Fig. 6a

[fsm|example_code :: HiddenClockResetEnable dom
                  => Signal dom Bool
                  -> Signal dom (Unsigned 2)
input i
var n = 0
fun loop ():
    let j = not i
    fun inc ():
        if j:
            n = n + 1
        else:
            skip
        ret ()
    let m = n
    let _ = call inc ()
    yield m
    ret call loop ()
ret call loop ()
|]

-- Fig. 10a

[fsm|counter :: HiddenClockResetEnable dom
             => Signal dom (Unsigned 4)
var i = 0
forever:
    do:
        yield i
        i = i + 1
    until i == maxBound
    do:
        yield i
        i = i - 1
    until i == 0
|]

-- Fig. 10b

counter_clash :: HiddenClockResetEnable dom
              => Signal dom (Unsigned 4)
counter_clash = moore f snd (False, 0) (pure ())
    where
    f (False, i) () = (j == maxBound, j)
        where j = i + 1
    f (True, i) () = (j /= 0, j)
        where j = i - 1

-- Fig. 12

[fsm|updn :: HiddenClockResetEnable dom
          => Signal dom (Bool, Bool)
          -> Signal dom (Unsigned 2)
input (i, j)
fun up (en, v):
    yield v
    let en1 = en /= i'
    if en1:
        if j':
            ret call dn (v + 1, en1)
        else:
            ret call up (en1, v - 1)
    else:
        ret call up (en1, v)
fun dn (v, en):
    yield v
    let en1 = en /= i'
    if en1:
        if j':
            ret call up (en1, v + 1)
        else:
            ret call dn (v - 1, en1)
    else:
        ret call dn (v, en1)
ret call up (False, 0)
|]

[fsm|updn_fixed :: HiddenClockResetEnable dom
                => Signal dom (Bool, Bool)
                -> Signal dom (Unsigned 2)
input (i, j)
fun up (en, v):
    yield v
    let en1 = en /= i'
    if en1:
        if j':
            ret call dn (en1, v + 1)
        else:
            ret call up (en1, v - 1)
    else:
        ret call up (en1, v)
fun dn (en, v):
    yield v
    let en1 = en /= i'
    if en1:
        if j':
            ret call up (en1, v + 1)
        else:
            ret call dn (en1, v - 1)
    else:
        ret call dn (en1, v)
ret call up (False, 0)
|]

