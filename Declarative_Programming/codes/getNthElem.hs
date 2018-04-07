getNthElem :: Int -> [a] -> a
getNthElem n (x:xs) = if n == 1
    then x
    else getNthElem (n-1) xs
