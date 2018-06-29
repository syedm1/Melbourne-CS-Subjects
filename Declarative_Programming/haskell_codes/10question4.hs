import Data.Char

str_to_num :: String -> Maybe Int
str_to_num [] = Nothing
str_to_num (d:ds) = str_to_num_acc 0 (d:ds)

str_to_num_acc :: Int -> String -> Maybe Int
str_to_num_acc n [] = Just n
str_to_num_acc n (d:ds) 
    | isDigit d = str_to_num_acc (10*n + (digitToInt d)) ds
    | otherwise = Nothing

sum_line :: IO Int
sum_line = do
    line <- getLine
    case str_to_num line of
        Nothing -> return 0
        Just num -> do
            sum <- sum_line
            return (sum+num)

sum_line' :: IO Int
sum_line' = 
    getLine >>=
    \line -> case str_to_num line of 
        Nothing -> return 0
        Just num -> 
            sum_line' >>=
            \sum -> return (sum+num)
