module Colouring 
(fullRNG
)where

import DataTypes

rng :: (Int,Int) -> Int -> Int
rng (min,max) seed = ((seed ^ 20) `mod` 2339 `mod` max) + min

fullRNG :: Int -> Figure -> FullFigure
fullRNG seed [] = []
fullRNG seed (x:xs) = ((genFill seed),(genOutline (seed + 10)),x):(fullRNG (seed + 11) xs)

genFill seed = (r1,r2,r3,r4,r5,r6) where
    [r1,r2,r3,r4,r5,r6] = genList (0,15) 6 seed
    
genOutline seed = (r1,r2,r3) where
    [r1,r2,r3] = genList (0,255) 3 seed

genList :: (Int,Int) -> Int -> Int -> [Int]
genList mm len seed = if len == 0
        then []
        else (rng mm seed):(genList mm (len - 1) (seed + 1))
