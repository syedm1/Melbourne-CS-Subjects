-- Author:  Haonan Li
-- Email:   <haonanl5@student.unimelb.edu.au>
-- Student ID : 955022

module Project1 (elementPosition, everyNth, elementBefore) where

--------------------------------------------------------------
-- Purpose: Take an element and a list, return the position --
-- of the first occurance of the element in the list.       --
--------------------------------------------------------------
elementPosition :: Eq t => t -> [t] -> Int
elementPosition t [] = 0
elementPosition t (x:xs) = if t == x
    then 1
    else (1 + elementPosition t xs) * haveElement t (x:xs)

-- judge the element exixt in the list
haveElement :: Eq t => t -> [t] -> Int
haveElement t [] = 0
haveElement t (x:xs) = if t == x
    then 1
    else haveElement t xs


--------------------------------------------------------------
-- Purpose: Take a number n and a list, return the list of  --
-- every nth element of the input list.                     --
--------------------------------------------------------------
everyNth :: Int -> [t] -> [t] 
everyNth 0 lst = error "Invalid number!"
everyNth t (x:xs) = everyNNth t t (x:xs)

-- the second parameter notes current position of the original list
everyNNth :: Int -> Int -> [t] -> [t]
everyNNth t p [] = []
everyNNth t p (x:xs) = if p == 1
    then [x] ++ everyNNth t t xs 
    else everyNNth t (p-1) xs


--------------------------------------------------------------
-- Purpose: Take an element and a list, return the element  --
-- immediately before the first appearence of the element   --
-- in the list.                                             --
--------------------------------------------------------------
elementBefore :: Eq a => a -> [a] -> Maybe a
elementBefore a lst = if elementPosition a lst == 0 || elementPosition a lst == 1
    then Nothing
    else Just (head (everyNth ((elementPosition a lst) -1) lst))
