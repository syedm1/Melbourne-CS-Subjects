appendList :: [a] -> [a] -> [a]
aopendList [] lst = lst
appendList (x:xs) lst = x:appendList xs lst
