--  File     : proj1test.hs
--  RCS      : $Id$
--  Author   : Peter Schachte
--  Origin   : Sat Aug 20 22:06:04 2011
--  Purpose  : Test program for proj1 project submissions

module Main where

import Data.List
import System.Environment
import System.Exit
import Project2

-- | Compute the correct answer to a guess.  First argument is the 
--   target, second is the guess.
response :: [String] -> [String] -> (Int,Int,Int)
response target guess = (right, rightKind, rightColor)
  where 
        common      = mintersect guess target
        right       = length common
        rguess      = foldr (delete) guess common
        rtarget     = foldr (delete) target common
        rightColor  = length $ mintersect (map (!!0) rguess) (map (!!0) rtarget)
        rightKind   = length $ mintersect (map (!!1) rguess) (map (!!1) rtarget)

mintersect :: Eq t => [t] -> [t] -> [t]
mintersect [] _ = []
mintersect (x:xs) r = if elem x r then x : mintersect xs (delete x r)
                      else mintersect xs r 

-- |Returns whether or not the guess passed in is a valid guess.  A
-- guess is valid if it is a list of at most size valid pieces 
validGuess :: Int -> [String] -> Bool
validGuess size guess =
  length guess <= size && all validPiece guess 

    
-- |Returns whether or not its argument is a piece.  That is, it
-- is a two-character string where the first character is between 'B'
-- or 'W' (upper case) and the second one of ['K','Q','R','N','B','P']
validPiece :: String -> Bool
validPiece piece =
  length piece == 2 && 
  piece!!0 `elem` ['B','W'] && 
  piece!!1 `elem` ['K','Q','R','N','B','P']


-- | Main program.  Gets the target from the command line (as three
--   separate command line arguments, each a note letter (upper case)
--   followed by an octave number.  Runs the user's initialGuess and
--   nextGuess functions repeatedly until they guess correctly.
--   Counts guesses, and prints a bit of running commentary as it goes.
main :: IO ()
main = do
  args <- getArgs
  let size = read (head args) :: Int
  let target = tail args
  let test = head args
  if validGuess size target then do
    let (guess,other) = initialGuess size
    loop size target guess other 1
    else do
    putStrLn "Usage:  proj1 s p1 p2 p3 ... pn"
    putStrLn "   where p1 .. pn are n pieces and n <= s"
    exitFailure


loop :: Int -> [String] -> [String] -> Project2.GameState -> Int -> IO ()
loop size target guess other guesses = do
  putStrLn $ "Your guess " ++ show guesses ++ ":  " ++ show guess
  if validGuess size guess then do
    let answer = response target guess
    putStrLn $ "My answer:  " ++ show answer
    if sort target == sort guess then do
      putStrLn $ "You got it in " ++ show guesses ++ " guesses!"
      else do
      let (guess',other') = nextGuess (guess,other) answer
      loop size target guess' other' (guesses+1)
    else do
    putStrLn "Invalid guess"
    exitFailure
