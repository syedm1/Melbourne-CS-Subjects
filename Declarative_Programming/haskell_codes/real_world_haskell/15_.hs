-- learn to use concatMap and replicate
repli::[a]->Int->[a]
repli lst n = concatMap (replicate n) lst
