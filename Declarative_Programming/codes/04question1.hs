
data Tree = Leaf | Node Int Tree Tree

build_bst::[Int] -> Tree
build_bst lst = build_bst' lst Leaf 

build_bst'::[Int] -> Tree -> Tree
build_bst' [] tree = tree
build_bst' (x:xs) tree = build_bst' xs (insert_bst x tree)

insert_bst::Int -> Tree -> Tree
insert_bst n Leaf = Node n Leaf Leaf
insert_bst n (Node k l r) 
    | n == k = Node n l r
    | n < k  = Node k (insert_bst n l) r
    | n > k  = Node k l (insert_bst n r)

traverse_bst::Tree -> [Int]
traverse_bst tree = traverse_bst' tree []

traverse_bst'::Tree -> [Int] -> [Int]
traverse_bst' Leaf lst = lst
traverse_bst' (Node k l r ) lst = (traverse_bst' l []) ++ [k] ++ (traverse_bst' r [])



