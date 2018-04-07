-- Input a number n, if n < 91, output n = 91.
mccarthy :: Int -> Int
mccarthy n = tmpfuc 1 n 

tmpfuc :: Int -> Int -> Int
tmpfuc 0 n = n
tmpfuc m n 
    = if n > 100 then 
        tmpfuc (m-1) (n-10)
    else
        tmpfuc (m+1) (n+11)

