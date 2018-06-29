main :: IO ()
main = do
    putStrLn "Input a sequence"
    len <- readln
    putStrLn $ "The length is " ++ (show len)

readln :: IO Int
readln = do
    str <- getLine
    return (length str)
