-- Insert a number into a sorted list
-- insert :: Ord a => a -> [a] -> [a]
insert :: [Int] -> Int -> [Int]
insert [] a = a:[]
insert (x:xs) a = 
    if a < x then
        a : (x:xs)
    else 
        x : insert xs a 
