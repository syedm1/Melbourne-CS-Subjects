-- Orignal :
--  File     : proj1test.hs
--  RCS      : $Id$
--  Author   : Peter Schachte
--  Origin   : Sat Aug 20 22:06:04 2011
--  Purpose  : Test program for proj1 project submissions

-- Modified :
-- Daniel Chan
-- Extended test program for Project 2 Sem 1 2018

module Main where

import Data.List
import System.Environment
import System.Exit
import Project2
import System.Random (randomRIO)
import Control.Exception
import Data.Time.Clock.POSIX (getPOSIXTime)

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


validateArgs :: Int -> Int -> Bool
validateArgs gameSize numberOfTargets =
 gameSize>=0 && gameSize<=32 && numberOfTargets>=0



main :: IO ()
main = do
  start <- (round . (* 1000)) <$> getPOSIXTime
  args <- getArgs
  let gameSize = read (args!!0) :: Int
  let numberOfTargets = read (args!!1) :: Int

  if validateArgs gameSize numberOfTargets then do
   (totalGuesses, totalTargetSize) <- executeLoop' gameSize numberOfTargets 0 0

   let averageGuesses = (fromIntegral totalGuesses) / (fromIntegral numberOfTargets)
   let averageTargetSize = (fromIntegral totalTargetSize) / (fromIntegral numberOfTargets)
   putStrLn $ "Game Size : " ++ (show gameSize)
   putStrLn $ "Number of Targets : " ++ (show numberOfTargets)
   putStrLn $ ""
   putStrLn $ "Average Guesses : " ++ (show averageGuesses)
   putStrLn $ "Average Target Size : " ++ (show averageTargetSize)
   end <- (round . (* 1000)) <$> getPOSIXTime
   let totalTime = end-start
   let averageTime = (fromIntegral totalTime) / (fromIntegral numberOfTargets)
   putStrLn $ "Total Time : " ++ (show totalTime) ++ " ms"
   putStrLn $ "Average Guess Time : " ++ (show averageTime) ++ " ms"
   
   else do
   putStrLn "Usage: Project2TestModified s n"
   putStrLn "Where: s is the game size (0-32) and n is the number of targets to generate"
   exitFailure


-- Input : game size, number of targets desired, number of guesses already made
-- total guesses required to solve all targets & average target size
executeLoop' :: Int -> Int -> Int -> Int -> IO((Int, Int))
executeLoop' _ 0 numberOfGuesses totalTargetSize= return (numberOfGuesses, totalTargetSize)
executeLoop' gameSize numberOfTargets numberOfGuesses totalTargetSize = do
 gamesetSize  <- randomRIO (0,gameSize)
 target <- getChessPieces gamesetSize fullChessSet 32 []
 let (guess, gameState) = initialGuess gameSize
 let guessesForTarget = solveTarget target guess gameState 1
 executeLoop' gameSize (numberOfTargets-1) (numberOfGuesses+guessesForTarget) (totalTargetSize + length target)

-- Input : number of pieces to add to starting set, set to choose from, length of set, starting set
-- ends when set to choose from runs out of pieces, or have added requisite pieces
-- Output : result set
getChessPieces :: Int -> [String] ->  Int -> [String]  -> IO([String])
getChessPieces 0 _ _ resultSet =  return resultSet
getChessPieces _ [] _ resultSet=  return resultSet
getChessPieces piecesToAdd set setLength resultSet = do
        (piece) <- takeRandomPiece set setLength
        getChessPieces (piecesToAdd-1) (delete piece set) (setLength-1) (piece:resultSet)

takeRandomPiece :: [String] -> Int -> IO(String)
takeRandomPiece [] _ = return ""
takeRandomPiece list listSize = do
  index <- randomRIO (0,listSize-1)
  return (list!!index)

-- takes a target, initial guess, initial gamestate, and current total guesses, returns guesses needed to solve
solveTarget :: [String] -> [String] -> Project2.GameState -> Int -> Int
solveTarget target guess gameState guesses
 | (sort target == sort guess) = guesses
 | otherwise =
    let
     answer = response target guess
     (guess',gameState') = nextGuess (guess,gameState) answer
    in 
     solveTarget target guess' gameState' (guesses+1)
  


-- Input : gameSize, number of targets
-- output : list of lists of chess pieces
-- Not used
generateTestSet :: Int -> Int -> [[String]] -> IO([[String]])
generateTestSet _ 0 resultSet = return resultSet
generateTestSet gameSize numberOfTargets resultSet = do
  gamesetSize  <- randomRIO (0,gameSize)
  newSet <- getChessPieces gamesetSize fullChessSet 32 []
  generateTestSet gameSize (numberOfTargets-1) (newSet:resultSet)

-- takes seed list of targets, size of game, and returns total number of guesses to solve all targets
-- Not used
executeLoop :: [[String]] -> Int -> Int -> Int
executeLoop [] _ total = total
executeLoop (x:xs) size total = executeLoop xs size (total + solveTarget x guess other 1) 
 where
  (guess,other) = initialGuess size

fullChessSet=["WP", "BP", "WP", "BP", "WP", "BP", "WP", "BP", "WP", "BP", "WP", "BP", "WP", "BP", "WP", "BP", "WB", "BB", "WR", "BR", "WN", "BN", "WB", "BB", "WR", "BR", "WN", "BN", "WQ", "BQ", "WK", "BK"]
