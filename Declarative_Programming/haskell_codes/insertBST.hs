data Tree a = Empty | Node (Tree a) a (Tree a)
    deriving Show  -- I added this for testing

    -- write a Haskell function \texttt{insert} to insert an element into a tree.
    -- Recall that in a BST, every element appearing in the first (left) subtree
    -- of a node must be smaller than the element of that node, and every element
    -- in the second (right) subtree must be larger.
    -- Note that this tree type does not have values, just keys. Include a type
    -- declaration for your \texttt{insert} function.
    -- You may use any function in the Haskell prelude, but not functions
    -- defined in libraries.

insert :: Ord a => a -> Tree a -> Tree a
insert a Empty = Node Empty a Empty
insert a (Node left b right)
    | a == b    = Node left b right
    | a <  b    = Node (insert a left) b right
    | otherwise = Node left b (insert a right)
