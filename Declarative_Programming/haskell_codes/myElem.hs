inList :: Eq t => t -> [t] -> Bool
inList t [] = False
--inList t (x:xs) = t == x || inList t xs
inList t (x:xs) 
    | t == x = True
    | otherwise = inList t xs
