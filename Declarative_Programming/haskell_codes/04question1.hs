
data Tree = Leaf | Node Int Tree Tree
    deriving (Show)

build_bst::[Int] -> Tree
build_bst [] = Leaf
build_bst (x:xs) = insert_bst x (build_bst xs)

insert_bst::Int -> Tree -> Tree
insert_bst n Leaf = Node n Leaf Leaf
insert_bst n (Node k l r) 
    | n <= k    = Node k (insert_bst n l) r
    | otherwise = Node k l (insert_bst n r)

traverse_bst::Tree -> [Int]
traverse_bst Leaf =[]
traverse_bst (Node k l r ) = (traverse_bst l) ++ [k] ++ (traverse_bst r)

