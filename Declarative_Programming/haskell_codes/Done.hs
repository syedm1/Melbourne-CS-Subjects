done :: Int -> IO ()
done n
    | n < 0 = putStrLn "Done."
    | otherwise = do
        print n
        done (n-1)
    
