split::[a]->Int->[[a]]
split [] _ = [[],[]]
split (x:xs) n
-- Don't forget to add tail 
--    | n > 0     = x : head (split xs (n-1))
    | n > 0     = [x : head output] ++ tail output 
    | otherwise = [[],xs]
        where output = split xs (n-1)
