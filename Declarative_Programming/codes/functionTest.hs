len [] = 0
len (x:xs) = 1 + len xs

len [] =
    0
len (x:xs) =
    1 +
    len xs
