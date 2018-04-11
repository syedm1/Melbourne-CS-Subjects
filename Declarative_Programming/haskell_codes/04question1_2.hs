
data Tree a = Empty | Node a (Tree a) (Tree a)

tree_sort::Ord a => [a] -> [a]
tree_sort lst = (traverse_bst . build_bst) lst

build_bst::Ord a => [a] -> Tree a
build_bst [] = Empty
build_bst (x:xs) = insert_bst x (build_bst xs)

insert_bst::Ord a => a -> Tree a -> Tree a
insert_bst n Empty = Node n Empty Empty
insert_bst n (Node k l r)
    | n <= k    = Node k (insert_bst n l) r
    | otherwise = Node k l (insert_bst n r)

traverse_bst::Tree a -> [a]
traverse_bst Empty = []
traverse_bst (Node k l r) = (traverse_bst l) ++ [k] ++ (traverse_bst r)

