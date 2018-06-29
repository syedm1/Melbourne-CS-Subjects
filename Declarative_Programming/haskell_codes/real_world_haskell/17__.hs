split::[a]->Int->[[a]]
split [] _ = [[],[]]
split (x:xs) n
-- Don't forget to add tail 
--    | n > 0     = x : head (split xs (n-1))
    | n > 0     = [x : head output] ++ tail output 
    | otherwise = [[],xs]
        where output = split xs (n-1)


-----
spl :: [a] -> Int -> [[a]]
spl (x:xs) n 
    | n > 0 = (x : head (spl xs (n-1))) : (tail (spl xs (n-1)))
    | otherwise = [[],(x:xs)]
