myReverse :: [a] -> [a]
myReverse lst = tmp lst []

tmp :: [a] -> [a] -> [a]
tmp [] lst = lst
tmp (x:xs) lst = tmp xs (x:lst)
