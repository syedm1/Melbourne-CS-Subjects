-- Q4
mysum :: Num a => [a] -> a
mysum l = foldl (+) 0 l

myproduct :: Num a => [a] -> a
myproduct l = foldl (*) 1 l

mysum' :: Num a => [a] -> a
mysum' [] = 0
mysum' (x:xs) = x + mysum' xs

-- Q5 ? 
filter_map :: (a -> Maybe b) -> [a] -> [b]
filter_map _ [] = []
filter_map f (x:xs) = 
    let fx = f x in
        case fx of
            Nothing -> filter_map f xs
            Just fxx -> fxx : filter_map f xs

-- Q6 wrong
-- all_pos :: (Num a) => [a] -> Bool
-- all_pos l = all (>0) l

-- Q6 right
all_pos :: (Ord a, Num a) => [a] -> Bool
all_pos l = all (>0) l

all_pos' :: (Num a, Ord a) => [a] -> Bool
all_pos' l = foldr ((&&).(>0)) True l

-- here, foldr and foldl are different. Depends on the function's args 
some_not_pos :: (Ord a, Num a) => [a] -> Bool
some_not_pos = foldr ((||).(<=0)) False

length' :: [a] -> Int
length' = foldr ((+).(const 1)) 0

-- Q7
map' :: (a -> b) -> [a] -> [b]
map' f = foldr ((:).f) []

-- what does 'id' means
filter' :: (a->Bool) -> [a] -> [a]
filter' f = foldr (\x -> if f x then (x:) else id) []

-- Q10
data Tree a = Empty | Node (Tree a) a (Tree a)
map_tree :: (a -> a) -> Tree a -> Tree a
map_tree _ Empty = Empty
map_tree f (Node l t r) = Node (map_tree f l) (f t) (map_tree f r)

-- Q11 !!!!
foldr_tree :: (a->b->a->a) -> a -> Tree b -> a
foldr_tree _ b Empty = b
foldr_tree f b (Node l n r) = f (foldr_tree f b l) n (foldr_tree f b r)
height_tree = foldr_tree (node_max_plus_1) 0
    where node_max_plus_1 l _ r = 1 + max l r
size_tree = foldr_tree (node_plus_1) 0
    where node_plus_1 l _ r = 1 + l + r
sum_tree = foldr_tree (ternary (+)) 0
concat_tree = foldr_tree (ternary (++)) []

ternary :: (a -> a -> a) -> a -> a -> a -> a
ternary f x y z = f x (f y z)



