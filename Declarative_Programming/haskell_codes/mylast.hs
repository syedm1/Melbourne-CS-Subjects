myLast xs = if length xs <= 1
    then xs
    else myLast (tail xs)
