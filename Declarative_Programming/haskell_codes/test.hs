append [] b = b
append(s:xs) b = s:append xs b
 
factorial :: Int -> Int 
factorial 0 = 1
factorial n = n * factorial (n-1)

longestPrefix :: Eq a => [a] -> [a] -> [a] 
longestPrefix [] _ = []
longestPrefix _ [] = []
longestPrefix (x:xs) (y:ys)
    | x == y    = x:longestPrefix xs ys
    | otherwise = []

transpose :: [[a]] -> [[a]]
transpose l
    | length (head l) > 0 = map head l : transpose (map tail l)
    | otherwise           = []


a1 :: Int -> Int
a1(0) = 1
a1(n) = n * a1(n-1)
