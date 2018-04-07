oddList :: [Int] -> [Int]
oddList [] = []
oddList (x:xs)  | odd x = x:(oddList xs)
                | otherwise = oddList xs
