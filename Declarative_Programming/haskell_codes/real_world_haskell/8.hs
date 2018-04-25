compress::Eq a=>[a]->[a]
compress [] = []
compress (x:xs) 
    | length xs == 0    = [x]
    | x == head xs      = compress xs
    | otherwise         = x : compress xs
