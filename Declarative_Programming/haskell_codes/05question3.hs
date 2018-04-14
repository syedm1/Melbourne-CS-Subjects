linearEqn :: Num a => a -> a -> [a] -> [a]
linearEqn a b = map (\x -> a*x+b)
