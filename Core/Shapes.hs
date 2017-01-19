module Shapes 
(recursivePolygon
,recursivePolygon_adv
,recursiveFigure
,recursiveFigure_adv
)
where

import DataTypes
import CoreSVG
import Utils
import Constants

recursivePolygon :: Polygon -> [Transformation] -> Int -> Figure
recursivePolygon basePolygon transList iter = 
    if iter > 0 
        then basePolygon:(recursivePolygon (transList |=> basePolygon) transList (iter - 1))
        else [] 

--takes a figure and recursively applies the transformation 
recursiveFigure :: Figure -> [Transformation] -> Int -> [Figure]
recursiveFigure baseFigure transList iter =
    map f baseFigure where
    f = (\poly -> recursivePolygon poly transList iter)
    
--same as recursivePolygon except it takes a transformation in the form of a function
--recursivePolygon_adv :: Polygon -> (Polygon -> Polygon) -> Int -> Figure
recursivePolygon_adv basePolygon transFunc iter =
    if iter > 0
        then basePolygon:(recursivePolygon_adv (transFunc basePolygon) transFunc (iter - 1))
        else []
        
recursiveFigure_adv :: [a] -> (a -> a) -> Int -> [[a]]
recursiveFigure_adv baseFigure transFunc iter =
    map f baseFigure where
    f = (\poly -> recursivePolygon_adv poly transFunc  iter)

--first tree:
--publishFigure $ centreFigure $ concat $ concat $ recursiveFigure_adv [[[(scale 0.4 1.4)] |=> square]] (\fig -> (map (\x -> [(translate 10 (-160)),(scale 0.75 0.75),(rot (-25))] |=> x) fig)++(map (\x -> [(translate 0 (-140)),(scale 0.75 0.75),(rot 25)] |=> x) fig)) 10