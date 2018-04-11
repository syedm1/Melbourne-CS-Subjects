-- Binary Search Tree

-- Basic data structure
data Tree = Leaf | Node String Int Tree Tree

-- Conut nodes of a BST
countnodes :: Tree -> Int
countnodes Leaf = 0
countnodes (Node _ _ l r) = 1 + (countnodes l) + (countnodes r)

-- Search a item in a BST
searchBST :: Tree -> String -> Maybe Int
searchBST Leaf _ = Nothing
searchBST (Node k v l r ) sk = 
    if sk == k then
        Just  v
    else if sk < k then
        searchBST l sk
    else 
        searchBST r sk

-- Insert a node to a BST
insertBST :: Tree -> String -> Int -> Tree
insertBST Leaf ik iv = Node ik iv Leaf Leaf
insertBST (Node k v l r) ik iv = 
    if ik == k then
        Node ik iv l r 
    else if ik < k then
        Node k v (insertBST l ik iv) r
    else 
        Node k v l (insertBST r ik iv)

-- Link a list of pairs to a BST
assocListToBST :: [(String, Int)] -> Tree
assocListToBST [] = Leaf
assocListToBST ((hk,hv):kvs) = 
    let t0 = assocListToBST kvs
    in insertBST t0 hk hv



{--
Another way to represente it
data Tree k v = Leaf | Node k v (Tree k v) (Tree k v)
countnode :: Tree k v -> Int
searchBST :: Tree k v -> k -> Maybe V
--}
