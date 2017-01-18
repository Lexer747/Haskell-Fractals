module Shapes 
(recursivePolygon
,recursiveFigure
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

recursiveFigure :: Figure -> [[Transformation]] -> Int -> Figure
recursiveFigure baseFigure transList iter =
    if iter > 0
        then baseFigure++(recursiveFigure (transformFigure transList baseFigure) transList (iter - 1))
        else []
