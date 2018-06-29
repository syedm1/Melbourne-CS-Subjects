pack::Eq a=>[a]->[[a]]
pack [] = []
pack (x:xs) = reverse(pack1 xs [[x]])

pack1::Eq a=>[a]->[[a]]->[[a]]
pack1 [] packed = packed
pack1 (x:xs) lst 
-- wrong
--    | x == head $ head lst  = pack1 xs ((x:head lst):tail lst)
    | x == (head $ head lst)  = pack1 xs ((x:head lst):tail lst)
-- No recursion
--    | otherwise             = [x]:lst
    | otherwise             = pack1 xs ([x]:lst)

