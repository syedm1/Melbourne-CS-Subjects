data Ttree t = Nil | Node3 t (Ttree t) (Ttree t) (Ttree t)

avg :: Ttree Double -> Double
avg Nil = 0.0
avg t = let (n,s) = count t in
    s / n

count :: Ttree Double -> (Double,Double)
count Nil = (0.0,0.0)
count (Node3 s t1 t2 t3) = 
    let 
        (n1,s1) = count t1
        (n2,s2) = count t2
        (n3,s3) = count t3
    in
        (1+n1+n2+n3,s+s1+s2+s3)

test_tree0 = Nil
test_tree1 = Node3 3.0 Nil Nil Nil
test_tree2 = Node3 3.0 (Node3 2.0 Nil Nil Nil) Nil Nil
test_tree3 = Node3 3.0 (Node3 2.0 Nil Nil Nil) (Node3 1.0 Nil Nil (Node3 4.0 Nil Nil Nil)) Nil
