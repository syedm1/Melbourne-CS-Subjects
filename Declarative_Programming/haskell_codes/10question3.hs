import Data.Char

str_to_num :: String -> Maybe Int
str_to_num [] = Nothing
str_to_num (d:ds) = str_to_num_acc 0 (d:ds)

str_to_num_acc :: Int -> String -> Maybe Int
str_to_num_acc n [] = Just n
str_to_num_acc n (d:ds) 
    | isDigit d = str_to_num_acc (10*n + (digitToInt d)) ds
    | otherwise = Nothing
