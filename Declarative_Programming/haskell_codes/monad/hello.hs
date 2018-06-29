hello::IO()
hello = 
    putStrLn "What is your name?"
    >>=
    \_ -> getLine
    >>=
    \name -> let msg = "Hello, " ++ name
        in putStrLn msg
