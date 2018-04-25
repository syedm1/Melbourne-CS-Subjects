data Encode_modified a = Multiple Int a | Single a
-- 'deriving (Show)' is need
    deriving (Show)
encode_modified::Eq a=>[a]->[Encode_modified a]
encode_modified lst = map encode_modified1 (encode lst)

encode_modified1::(Int,a)->Encode_modified a
encode_modified1 (n,a) 
    | n==1      = Single a
    | otherwise = Multiple n a

encode::Eq a=>[a]->[(Int,a)]
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

