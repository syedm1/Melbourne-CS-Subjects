num_of_elem::[a]->Int
num_of_elem [] = 0
num_of_elem lst = 1 + num_of_elem (tail lst)
