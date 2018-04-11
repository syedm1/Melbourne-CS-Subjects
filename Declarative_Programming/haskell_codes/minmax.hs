-- Give two number min, max. Build a list from min to max
minmax :: Int -> Int -> [Int]
minmax a b = 
    if a <= b then
        a:minmax (a+1) b 
    else
        []
