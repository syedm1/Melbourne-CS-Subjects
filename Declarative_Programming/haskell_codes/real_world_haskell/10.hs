encode::Eq a=>[a]->[(Int,a)]
-- Wrong use of "map",  map have two arguments, the first is a funtion and the second is a list
-- encode lst = (map.encode1) (pack lst)
encode lst = map encode1 (pack lst)

encode1::[a]->(Int,a)
encode1 lst = ((length lst), (head lst))

pack::Eq a=>[a]->[[a]]
pack [] = []
pack (x:xs) = reverse(pack1 xs [[x]])

pack1::Eq a=>[a]->[[a]]->[[a]]
pack1 [] packed = packed
pack1 (x:xs) lst 
    | x == (head $ head lst)  = pack1 xs ((x:head lst):tail lst)
    | otherwise             = pack1 xs ([x]:lst)

