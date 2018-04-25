slice::[a]->Int->Int->[a]
slice lst st nd = [x | (x,i) <- zip lst [1..nd], i >= st]
