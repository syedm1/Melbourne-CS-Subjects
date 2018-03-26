-- Author:  Haonan Li
-- Email:   <haonanl5@student.unimelb.edu.au>
-- Student ID : 955022

-- Thinking: If you are sure one is in the set, then you should contain it is your guess anytime.


module Project2 (initialGuess, nextGuess, GameState) where


















{-

-----------------------------------------------------------------------------
-- Naive solution:Guess every piece seperately. Each time, we just put     --
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



{-

-- takes an input argument giving the size of the game, and returns a pair of an initial guess and a game state.
-- Chess Elements
data Color = Black | White
    deriving (Show)
data Kind = King | Queen | Rook | Bishop | Knight | Pawn
    deriving (Show)
data Piece = BK | BQ | BR | BB | BN | BP | WK | WQ | WR | WB | WN | WP
    deriving (Show)

-- GameState Elements
data GameConts
    = ColorCont Color Int
    | KindCont Kind Int
    | PieceCont Piece Int
    deriving (Show)

    gs = ["BK","BQ","BR","BR","BB","BB","BN","BN","BP","BP","BP","BP","BP","BP","BP","BP", 
            "WK","WQ","WR","WR","WB","WB","WN","WN","WP","WP","WP","WP","WP","WP","WP","WP"]

-- GameState: include all number of Chess Element
type GameState = [GameConts]

-}
