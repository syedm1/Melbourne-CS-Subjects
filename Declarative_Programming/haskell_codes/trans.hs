trans :: [[a]] -> [[a]]
trans [] = []
trans l
    | length (head l) > 0 = map head l : trans (map tail l)
    | otherwise           = []
