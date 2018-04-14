maybeApply :: (a -> b) -> Maybe a -> Maybe b
maybeApply f a
    | a == Nothing  = Nothing
    | otherwise     = Just $ f a
