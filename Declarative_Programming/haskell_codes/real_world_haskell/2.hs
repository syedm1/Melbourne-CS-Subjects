last_but_one::[a]->a
last_but_one list
    | (length list)<2   = error "error"
    | otherwise         = (head.tail.reverse) list
