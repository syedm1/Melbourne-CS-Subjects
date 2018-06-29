-- Wrong type
-- palindrom::[a]->Bool
palindrom::Eq a => [a]->Bool
palindrom lst
    | (length lst)<2    = True
-- Wrong writing    
--    | otherwise         = ((head lst) == ((head.reverse) lst)) & palindrom ((tail.reverse.tail.reverse) lst)
    | otherwise         = ((head lst) == ((head.reverse) lst)) && palindrom ((tail.reverse.tail.reverse) lst)

ispal :: Eq a => [a] -> Bool
ispal a = a == foldl (flip (:)) [] a
