maybe_tail :: [a] -> Maybe [a]
maybe_tail [] = Nothing
maybe_tail (_:xs) = Just xs

maybe_drop :: Int -> [a] -> Maybe [a]
maybe_drop 0 a = Just a
maybe_drop n l | n > 0 = maybe_tail l >>= maybe_drop (n-1)


maybe_drop' :: Int -> [a] -> Maybe [a]
maybe_drop' 0 a = Just a
maybe_drop' n xs = 
    let mt = maybe_tail xs in
    case mt of
        Nothing -> Nothing
        Just xs1 -> maybe_drop' (n-1) xs1
