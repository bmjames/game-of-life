{-# LANGUAGE DeriveFunctor #-}

module Main where

import Control.Applicative (liftA2)
import Control.Comonad
import qualified Data.List.Zipper as Z

data PlaneZipper a = PZ (Z.Zipper (Z.Zipper a)) deriving Functor

up :: PlaneZipper a -> PlaneZipper a
up (PZ z) = PZ $ Z.left z

down :: PlaneZipper a -> PlaneZipper a
down (PZ z) = PZ $ Z.right z

left :: PlaneZipper a -> PlaneZipper a
left (PZ z) = PZ $ fmap Z.left z

right :: PlaneZipper a -> PlaneZipper a
right (PZ z) = PZ $ fmap Z.right z

readCell :: PlaneZipper a -> a
readCell (PZ z) = Z.cursor $ Z.cursor z

move :: (a -> a) -> (a -> a) -> a -> Z.Zipper a
move f g z = Z.Zip (iterate1 f z) (iterate g z)
  where iterate1 f' = tail . iterate f'

horizontal :: PlaneZipper a -> Z.Zipper (PlaneZipper a)
horizontal = move left right

vertical :: PlaneZipper a -> Z.Zipper (PlaneZipper a)
vertical = move up down

instance Comonad PlaneZipper where
  extract = readCell
  duplicate = PZ . fmap horizontal . vertical

neighbours :: [PlaneZipper a -> PlaneZipper a]
neighbours = horiz ++ vert ++ liftA2 (.) horiz vert
  where horiz = [left, right]
        vert  = [up, down]

aliveNeighbours :: PlaneZipper Bool -> Int
aliveNeighbours z = count (\dir -> extract $ dir z) neighbours
  where count p = length . filter p

rule :: PlaneZipper Bool -> Bool
rule z = case aliveNeighbours z of
  2 -> extract z
  3 -> True
  _ -> False

evolve :: PlaneZipper Bool -> PlaneZipper Bool
evolve = extend rule

disp :: PlaneZipper Bool -> String
disp (PZ z) = unlines $ map dispLine $ toList 6 z
  where dispLine z' = map dispChar $ toList 6 z'
        dispChar True  = '*'
        dispChar False = ' '
        toList n (Z.Zip ls rs) = reverse (take n ls) ++ take n rs 

glider :: PlaneZipper Bool
glider = PZ $ Z.Zip (repeat fz) rs
  where rs = [ line [False, True,  False]
             , line [False, False, True]
             , line [True,  True,  True]
             ] ++ repeat fz
        fl = repeat False
        fz = Z.Zip fl fl
        line l = Z.Zip fl (l ++ fl)

main :: IO ()
main = let evolution = iterate evolve glider
       in mapM_ (putStr . disp) (take 5 evolution)
