module Shapes 
(recursiveFigure
)
where

import DataTypes
import CoreSVG
import Utils

recursiveFigure :: Polygon -> [Transformation] -> Float -> Figure
recursiveFigure basePolygon transList iter = 
    if steps 
        then (basePolygon):(recursiveFigure (transformPolygon transList basePolygon) transList (iter - 1))
        else [] where
            steps = iter > 0