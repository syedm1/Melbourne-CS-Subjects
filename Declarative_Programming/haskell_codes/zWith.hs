zWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zWith f [] _ = []
zWith f _ [] = []
zWith f (x:xs) (y:ys) = f x y : zWith f xs ys
