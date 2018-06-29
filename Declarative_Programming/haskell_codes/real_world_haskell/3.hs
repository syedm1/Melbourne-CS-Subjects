-- Wrong writing
-- k_th::Int n => n->[a]->a

k_th::Int->[a]->a
k_th n lst
    | (length lst) < n  = error "error"
    | 1 < n             = k_th (n-1) (tail lst)
    | otherwise         = head lst
