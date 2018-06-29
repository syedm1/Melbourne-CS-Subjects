data Tree a = Empty | Node (Tree a) a (Tree a)

print_tree :: Show a => Tree a -> IO ()
print_tree Empty = return ()
print_tree (Node l e r) = do
    print_tree l
    print e 
    print_tree r


testTree :: Tree Int
testTree = Node (Node Empty 10 Empty) 20 (Node Empty 30 (Node Empty 40 Empty))
