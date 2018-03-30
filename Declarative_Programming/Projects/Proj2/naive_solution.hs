{-
-----------------------------------------------------------------------------
-- Solution two :  Guess every piece seperately. Each time, we just put    --
-- one kind of piece into the guess set. If the hinder returns a number    --
-- of correct pieces equal with the size of our guess set, put one more    --
-- same item into the set, until the returned correct pieces smaller than  --
-- the guess set size n, put n-1 this piece into the certained set. When   --
-- we go through all kinds of pieces, our certained set is the result.     --
-- This is a naive solution because it does not use all feedback, include  --
-- the correct kinds and correct color indormation. It will take at most   --
-- 32 + 12 = 44 times to get the answer.                                   --
-----------------------------------------------------------------------------

-- Initialize the guess with one first piece.
initialGuess :: Int -> ([String],GameState)
initialGuess size = (st, (cer, all)) where 
    st = ["BK"]
    cer = []
    all = ["BK","BQ","BR","BB","BN","BP","WK","WQ","WR","WB","WN","WP"]

-- Next guess, guess next piece or one more the same piece
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess (bgs,(bcer,all)) (t1,t2,t3)
    = (gs,(cer,all)) where
        cer 
            | t1 < length bgs   = bcer ++ tail bgs
            | otherwise         = bcer
        gs
            | t1 < length bgs && 
              (head bgs) == (head . reverse) all    = cer
            | t1 < length bgs                       = [after (head bgs) all]
            | otherwise                             = (head bgs) : bgs

-- Return the item after the given item in the list
after :: (Eq a) => a -> [a] -> a
after a (x:xs) 
    | a == x = head xs
    | otherwise = after a xs

-- Save the current guess information, first component is certained pieces,
-- second component contain all kinds of pieces.
type GameState = ([String], [String])

-}

