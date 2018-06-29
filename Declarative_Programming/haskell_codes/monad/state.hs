import Control.Monad.State

data Tree a = Empty | Node (Tree a) a (Tree a) deriving Show
type IntTree = Tree Int

testTree :: IntTree
testTree = Node (Node Empty 10 Empty) 20 (Node Empty 30 (Node Empty 40 Empty))

incTree :: IntTree -> IntTree
incTree tree = fst (runState (incTree1 tree) 1)

incTree1 :: IntTree -> State Int IntTree
incTree1 Empty = return Empty
incTree1 (Node l e r) = do
    newl <- incTree1 l
    n <- get
    put (n+1)
    newr <- incTree1 r
    return (Node newl (e+n) newr)
