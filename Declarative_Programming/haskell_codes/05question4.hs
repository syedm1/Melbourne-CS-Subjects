sqrtPM :: (Floating a, Ord a) => a -> [a]
sqrtPM x
  | x  > 0    = let y = sqrt x in [y, -y]
  | x == 0    = [0]
  | otherwise = []

allSqrts :: (Floating a, Ord a) => (a -> [a]) -> [a] ->[a]
allSqrts f lst = concatMap f lst
