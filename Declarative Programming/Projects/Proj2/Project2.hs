-- Author:  Haonan Li
-- Email:   <haonanl5@student.unimelb.edu.au>
-- Student ID : 955022


module Project2 (initialGuess, nextGuess, GameState) where

import Data.List
type GameState = (Int, [[String]])

-- Initial guess: guess all pieces are "BP", the guess set size is the size of the game. Trough this initial, I can know the number of "BP" and the number of "WP", and the number of BLACK pieces except "BP". Thess three informatin is very useful to reduce the possible sets.
initialGuess :: Int -> ([String],GameState)
initialGuess size = (st, (0,[])) where 
    st = repeatt size ["BP"]

-- Tools: repeat one element of give times in a list
repeatt :: Int -> [a] -> [a]
repeatt n (x:xs)
    | n == 0 = xs
    | otherwise = [x] ++ (repeatt (n-1) (x:xs))

-- Return all possible subsets of a given list
subSet :: Int -> [String] -> [[String]]
subSet 0 _ = [[]]
subSet _ [] = [[]]
subSet n (x:xs) 
    | n > (length xs) + 1 = subSet (n-1) (x:xs)
    | otherwise = (subSet n xs) ++ (add x (subSet (n-1) xs))

-- Delete repeated element in a list
prune :: (Eq a) => [a] -> [a] -> [a]
prune a [] = a
prune a (x:xs) 
    | elem x a = prune a xs
    | otherwise = prune ([x] ++ a) xs

-- Add one element to every element list in a list [[a]]
add :: a -> [[a]] -> [[a]]
add a [] = []
add a (x:xs) = [([a] ++ x )] ++ (add a xs)

-- Add each element in a list [a] to every element list in a list [[a]]
addl :: [a] -> [[a]] -> [[a]]
addl a [] = []
addl a (x:xs) = [(a ++ x )] ++ (addl a xs)

-- Return a element with longest length in a list
longest :: [String] -> [[String]] -> [String]
longest a [] = a
longest a (x:xs)
    | length a > length x = longest a xs
    | otherwise = longest x xs


-- Initial guess can get exactly information, other do same process, always guess the longest candidate set.
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess (bgs,(nth, bcand)) (t1,t2,t3) 
    = (gs,((nth+1),cand)) where
        pieces1 = ["BK","BQ","BR","BR","BB","BB","BN","BN"]
        pieces2 = ["WK","WQ","WR","WR","WB","WB","WN","WN"]
        cand 
            | nth == 0  = addl ((repeatt t1 ["BP"]) ++ (repeatt t2 ["WP"])) 
                            [ x ++ y | x <- (prune [] (subSet t3 pieces1)), y <- (prune [] (subSet ((length bgs)-t1-t2-t3) pieces2))]
            | otherwise =  filter (same_res bgs (t1,t2,t3)) bcand
        gs = longest [] cand

-- A filter, compare the result of our own judgement system with the tuple received from hinder. If the same, retain the set as candidate, if not, delete it from candidate set.
same_res :: [String] -> (Int,Int,Int) -> [String] -> Bool
same_res bgs (t1,t2,t3) x
    | judge x bgs == (t1,t2,t3) = True
    | otherwise = False


-- Copy from test code
judge :: [String] -> [String] -> (Int,Int,Int)
judge cand guess = (right, right_kind, right_color) where 
        common      = mintersect guess cand
        right       = length common
        rguess      = foldr (delete) guess common
        rcand       = foldr (delete) cand common
        right_color  = length $ mintersect (map (!!0) rguess) (map (!!0) rcand)
        right_kind   = length $ mintersect (map (!!1) rguess) (map (!!1) rcand)

mintersect :: Eq a => [a] -> [a] -> [a]
mintersect [] _ = []
mintersect (x:xs) r 
    | elem x r = x : mintersect xs (delete x r)
    | otherwise = mintersect xs r 







{-

-----------------------------------------------------------------------------
-- Naive solution: Guess every piece seperately. Each time, we just put    --
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

