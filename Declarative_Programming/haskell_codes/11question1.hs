fib :: Int -> [Int]
-- fib 0 = []
-- fib 1 = [0]
-- fib n = 0:1:fib' 0 1 (n-2)
-- 
-- fib' _ _ 0 = []
-- fib' fpp fp n = (fpp+fp) : fib' fp (fpp+fp) (n-1)

fib n = take n $ 0:1:fibb 0 1 []
fibb :: Int -> Int -> [Int] -> [Int]
fibb a b lst = (a+b) : fibb b (a+b) lst

