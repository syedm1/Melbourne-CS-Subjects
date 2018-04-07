import Data.Char(toUpper)

-- method1
-- upperCase :: String -> String
-- upperCase [] = []
-- upperCase (x:xs) = toUpper x : upperCase  xs

-- method2
upperCase xs = map toUpper xs
