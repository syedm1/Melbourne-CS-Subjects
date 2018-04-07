
get_info::Num a => [a] -> (Int, a, a)
get_info lst = (len_, sum_, sum_square) 
    where
        len_ = length lst
        sum_ = foldr (+) 0 lst
        sum_square = foldr (+) 0 $ map f lst
            where 
                f a = a*a
