-- Longest prefix of two string
longPre :: Eq t => [t] -> [t] -> [t] 
longPre _ [] = []
longPre [] _ = []
longPre (x:xs) (y:ys)
    | x == y = x:longPre xs ys
    | otherwise = []
