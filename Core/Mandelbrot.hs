module Mandelbrot where

import CoordinateSystem
import CoreIO
import DataTypes


height :: Int
height = 300
width :: Int
width = 300

iterations :: Int
iterations = 50

infinity :: Float
infinity = 4

-- colourMap Iterations -> Occurances
-- colourMap :: HashMap Int Int 
-- colourMap = empty 


mandelbrotFunc :: Pixel -> Pixel
mandelbrotFunc pixel = Pixel (location pixel) representative where
    representative = mandelColour iter
    iter = applyMandel iterations curPoint
    curPoint = normalizePixel pixel

mandelColour :: Int -> Outline
mandelColour iter = if (fromIntegral iter) == iterations then (0,0,0) else (c,c,c) where
    c = floor (normalize (fromIntegral iter) 0 (fromIntegral iterations) 100 255)
    
applyMandel :: Int -> (Float, Float) -> Int
applyMandel n (x,y) = applyMandel_help n (x,y) (x,y) 0
    
--applyMandel will take a number of function iterations to do and return how many it managed to perform on a point
applyMandel_help :: Int -> (Float,Float) -> (Float,Float) -> Int -> Int
applyMandel_help 0 _ _ acc = acc
applyMandel_help n (baseX,baseY) (x,y) acc = 
    if (newX + newY) > infinity 
        then acc
        else (applyMandel_help (n-1) (baseX,baseY) (newX,newY) (acc + 1)) where
            newX = baseX +((x * x) - (y * y))
            newY = baseY + (2 * x * y)

normalize :: Fractional a => a -> a -> a -> a -> a -> a
normalize cur min max newMin newMax = (((newMax - newMin) * (cur - min)) / (max - min)) + newMin

normalizePixel :: Pixel -> (Float, Float)
normalizePixel pixel = (newX, newY) where
    (x,y) = location pixel
    newX = (normalize (fromIntegral x) 0 (fromIntegral width) (-1.5) 1.5)
    newY = (normalize (fromIntegral y) 0 (fromIntegral height) (-1.5)1.5)

-- | to create the set we map the mandelbrotFunc over every pixel in the grid
mandelbrotSet = convertGrid $ mapGrid mandelbrotFunc $ buildGrid height width whitePixel

