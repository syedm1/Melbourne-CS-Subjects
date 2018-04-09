module Project2 (initialGuess, nextGuess, GameState) where

type GameState = (Int, Bool, [String], [String], [String])

initialGuess :: Int -> ([String],GameState)
initialGuess size = (gs, (1,True,bl,wh,[])) where 
    gs = replicate size "BP"
    bl = ["BP", "BN", "BB", "BR", "BQ", "BK"]
    wh = ["WP", "WN", "WB", "WR", "WQ", "WK"]

nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess (guess, (n, gs_bl, bl, wh, cer)) (f1,f2,f3) 
    = (new_guess,((n+1),ngs_bl,bl,wh,new_cer)) where
        ngs_bl = if f3 > 0 then True else False
        new_size = (length guess) - f1 - f2
        new_cer 
            | gs_bl = cer ++ (replicate (f1-(length cer)) (nth n bl)) ++ (replicate f2 (nth n wh))
            | otherwise = cer ++ (replicate (f1-(length cer)) (nth n wh))
        new_guess 
            | (n < 6) && ngs_bl = new_cer ++ (replicate ((length guess)-f1-f2) (nth (n+1) bl))
            | (n < 6) && (not ngs_bl) = new_cer ++ (replicate ((length guess)-f1-f2) (nth (n+1) wh))
            | n == 6 = if ((length guess)-f1==0) then new_cer ++ ["WK"] else new_cer 

nth::Int -> [a] -> a
nth n lst = if n == 1 then head lst else nth (n-1) (tail lst)
