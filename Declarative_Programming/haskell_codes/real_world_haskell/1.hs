find_last::[a]->a
find_last [] = error "error"
find_last (x:xs) 
    | (length xs) == 0  = x
    | otherwise         = find_last xs
