reverse1::[a]->[a]
reverse1 [] = []
reverse1 (x:xs) = reverse1 xs ++ [x]
