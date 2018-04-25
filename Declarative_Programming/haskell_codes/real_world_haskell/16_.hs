drop_every::[a]->Int->[a]
drop_every lst n = drop_every1 lst n n

drop_every1::[a]->Int->Int->[a]
drop_every1 [] _ _ = []
drop_every1 (x:xs) n m 
    | m == 1    = drop_every1 xs n n
    | otherwise = x:drop_every1 xs n (m-1)


-- Learn to use 'zip' 'filter' 'lambda' and '[1..]'
-- Answer
-- caution : not equal should write '/=', rather than '\='
dropEvery lst n = map head $ filter (\(x,i)-> i `mod` n /= 0) $ zip lst [1..]
