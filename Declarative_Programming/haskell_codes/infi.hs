recycle::[t] -> [t]
--recycle [t] = t:recycle [t]

recycle l = recycle1 l l
recycle1 [] l = recycle1 l l
recycle1 (x:xs) l = x:recycle1 xs l
