--  Filter the negative number of a list
negativeFilt :: [Int] -> [Int]
negativeFilt [] = []
negativeFilt (x:xs)  = 
    if x < 0 then
        negativeFilt xs
    else 
        x : negativeFilt xs
