-- Author       : Haonan Li
-- Email        : <haonanl5@student.unimelb.edu.au>
-- Student ID   : 955022


module Project2 (initialGuess, nextGuess, GameState) where

import Data.List
type GameState = (Int, [[String]])


-- Function : Initial guess, guess with all "BP" and size is size of the 
--            game. Gamestate saves times of guesses and the candidate target 
--            sets. It will initialize at the second guess.
-- Input    : One number.
-- Output   : One guess set and a gamestate tuple.
initialGuess :: Int -> ([String],GameState)
initialGuess size = (gs, (1,[])) where 
    gs = replicate size "BP"


-- Function : Return a element with longest length in a list
-- Input    : A empty list and a list (L) of list of String.
-- Output   : A list of String whoes length is the largest of the given list L.
longest :: [[String]] -> [String]
longest [a] = a
longest (x:y:z)
    | length x > length y = longest (x:z)
    | otherwise           = longest (y:z)


-- Function : Decide the next guess using received message and current game 
--            state. We process the second guess seperatly because of 
--            initilization of candidate sets. For the nth guess (n>2). We 
--            always judge every candidate set with the last guess, if the 
--            result is the same with the result received from hinder, keep it
--            in candidates, after this, we just choose one longest set of the
--            candidates as new guess.
-- Input    : A tuple of [String] and GameState, and a tuple of three integers. 
-- Output   : A tuple of [String] and GameState, They are new guess and updated
--            game state seperately.
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess (bgs,(nth, bcand)) guess_res
    | nth == 1  = secondGuess (bgs,(nth, bcand)) guess_res
    | otherwise = (gs,((nth+1),cand)) where
        cand = filter (sameRes bgs guess_res) bcand
        gs   = longest cand


-- Function : The second guess, From initial guess, We can know the number 
--            of "BP" and "WP" and Black pieces except "BP". We initialize 
--            candidate target set with these informations. And find one with 
--            largest length as the second guess.
-- Input    : A tuple of [String] and GameState, and a tuple of three integers.
-- Output   : A tuple of [String] and GameState, They are new guess and updated
--            game state seperately.
secondGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)   
secondGuess (bgs,(nth, bcand)) (t1,t2,t3) = (gs,((nth+1),cand)) where
    pieces1 = ["BK","BQ","BR","BR","BB","BB","BN","BN"]
    pieces2 = ["WK","WQ","WR","WR","WB","WB","WN","WN"]
    cand    = map ((++) ((replicate t1 "BP") ++ (replicate t2 "WP"))) 
        [ x ++ y | 
            x <- (filter (prune t3) (subsequences pieces1)), 
            y <- (filter (prune max_n_white) (subsequences pieces2))] where
                max_n_white = ((length bgs)-t1-t2-t3)
    gs      = longest cand


-- Function : A filter, tell if the list length no larger than the given number.
-- Input    : A number N and a list L.
-- Output   : If the length of L no larger than N
prune :: Int -> [String] -> Bool
prune n a = n >= length a


-- Function : A filter, compare the result of my own judgement system with the 
--            tuple received from hinder. If they are the same, retain the set 
--            as candidate, if not, delete it from candidate set.
-- Input    : A guess list and tuple of three integers, and a target list.
-- Output   : A Bool value, indicate whether given guess and target can compute
--            the given answer.
sameRes :: [String] -> (Int,Int,Int) -> [String] -> Bool
sameRes bgs (t1,t2,t3) x
    | myJudge x bgs == (t1,t2,t3) = True
    | otherwise                   = False


-- Function : Compute the size of common element, right kind of guess and right
--            color of guess.
-- Input    : A guess list and a target list.
-- Output   : A tuple with three integers, indicate the number of same elements,
--            same kind but different color elements and same color but 
--            edifferent kind lements.
myJudge :: [String] -> [String] -> (Int,Int,Int)
myJudge cand gs = (n_same, n_same_k, n_same_c) where 
    same      = myIntersect gs cand
    n_same    = length same 
    n_same_c  = length (myIntersect (map (!!0) gs) (map (!!0) cand)) - n_same
    n_same_k  = length (myIntersect (map (!!1) gs) (map (!!1) cand)) - n_same


-- Function : Computer the insetsection of two lists.
-- Input    : Two list L1, L2.
-- Output   : One list of the same elements in L1 and L2.
myIntersect :: Eq a => [a] -> [a] -> [a]
myIntersect [] _ = []
myIntersect (x:xs) a
    | x `elem` a = x : myIntersect xs (delete x a)
    | otherwise  = myIntersect xs a

