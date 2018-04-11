-- zip
transpose::[[a]] -> [[a]]
transpose lst
    | length lst == 0           = error "empty list"
    | length (head lst) == 0    = []
    | otherwise                 = map head lst:transpose (map tail lst)
