module Recursive where

import DataTypes
import Utils ((|=>))

recursivePolygon :: Polygon -> [Transformation] -> Int -> Figure
recursivePolygon basePolygon transList iter
    | iter > 0  = basePolygon:(recursivePolygon (transList |=> basePolygon) transList (iter - 1))
    | otherwise = [] 

--takes a figure and recursively applies the transformation 
recursiveFigure :: Figure -> [Transformation] -> Int -> [Figure]
recursiveFigure baseFigure transList iter =
    map f baseFigure where
    f = (\poly -> recursivePolygon poly transList iter)
    
--same as recursivePolygon except it takes a transformation in the form of a function
recursivePolygon_adv :: a -> (a -> a) -> Int -> [a]
recursivePolygon_adv basePolygon transFunc iter 
    | iter > 0  = basePolygon:(recursivePolygon_adv (transFunc basePolygon) transFunc (iter - 1))
    | otherwise = []
        
recursiveFigure_adv :: [a] -> (a -> a) -> Int -> [[a]]
recursiveFigure_adv baseFigure transFunc iter =
    map f baseFigure where
    f = (\poly -> recursivePolygon_adv poly transFunc iter)
    
    
--should allow you to perfrom a recursive transformation to a shape.
recursiveTransform :: 
    [a] 
    -> ([Transformation] -> a -> a) 
    -> [Transformation] 
    -> ([Transformation] -> [Transformation]) 
    -> Int -> [[a]]
recursiveTransform base partial ts changeTs iter
    | iter > 0  = base:(recursiveTransform applied partial nextTs changeTs (iter-1))
    | otherwise = []
    where
        applied     = map (partial ts) base
        nextTs      = changeTs ts