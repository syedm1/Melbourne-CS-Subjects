-- Merge two sorted list
mergeSortedList :: Ord a => [a] -> [a] -> [a]
mergeSortedList xx yy 
    | length xx == 0 = yy
    | length yy == 0 = xx
    | head xx <= head yy = (head xx) : (mergeSortedList (tail xx) yy)
    | otherwise = (head yy) : (mergeSortedList xx (tail yy))
