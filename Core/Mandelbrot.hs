module Mandelbrot where

import CoordinateSystem
import CoreIO
import DataTypes


height :: Int
height = 480
width :: Int
width = 640

iterations :: Int
iterations = 1000

zoom :: Fractional a => a
zoom = 0.75

gap :: Fractional a => a
gap = 1 / (zoom)

basePoint :: Fractional a => (a,a)
basePoint = ((-0.5),0)

mandelXmin (x,_) = (x - gap)
mandelXmax (x,_) = (x + gap)
mandelYmin (_,y) = (y - gap)
mandelYmax (_,y) = (y + gap)

-- customMandelFunc :: Point -> Float -> (Pixel -> Pixel)
customMandelFunc base zoom pixel = Pixel (location pixel) representative where
    representative = mandelColour iter
    iter = applyMandel iterations curPoint 
    curPoint = customNormalizePixel base zoom pixel


-- mandelbrotFunc :: Pixel -> Pixel
mandelbrotFunc pixel = Pixel (location pixel) representative where
    representative = mandelColour iter
    iter = applyMandel iterations curPoint
    curPoint = normalizePixel pixel

-- mandelColour :: Int -> Outline
mandelColour iter = if (fromIntegral iter) == iterations then (0,0,0) else (r,g,b) where
    r = round $ t * ( 1 + sin t) / 1
    -- if (x < (255 :: Int)) && (x >= (15 :: Int)) then (normalize x 15 765 15 255) else 15
    -- g = if (x < 510) && (x >= 255) then (floor $ normalize x 15 765 15 255) else 15
    -- b = if (x < 765) && (x >= 510) then (floor $ normalize x 15 765 15 255) else 15
    g = round $ t * ( 1 + cos t) / 1
    b = round $ t * ( 1 + cos(sin t)) / 1
    t = normalize (sqrt brightness) 0 1 15 255 --240
    brightness = normalize (fromIntegral iter) 0 (fromIntegral iterations) 0 1
-- applyMandel :: Int -> Point -> Int
applyMandel n (x,y) = applyMandel_help n (x,y) (x,y) 0
    
--applyMandel will take a number of function iterations to do and return how many it managed to perform on a point
-- applyMandel_help :: Int -> Point -> Point -> Int -> Int
applyMandel_help 0 _ _ acc = acc
applyMandel_help n (baseX,baseY) (x,y) acc = 
    if  (sqrt $ (newX * newX) + (newY * newY)) > 16
        then acc
        else (applyMandel_help (n-1) (baseX,baseY) (newX,newY) (acc + 1)) where
            newX = baseX +((x * x) - (y * y))
            newY = baseY + (2 * x * y)

-- normalize :: Fractional a => a -> a -> a -> a -> a -> a
normalize cur min max newMin newMax = (((newMax - newMin) * (cur - min)) / (max - min)) + newMin

-- normalizePixel :: Pixel -> Point
normalizePixel pixel = (newX, newY) where
    (x,y) = location pixel
    newX = normalize (fromIntegral x) 0 (fromIntegral width) (mandelXmin basePoint) (mandelXmax basePoint)
    newY = normalize (fromIntegral y) 0 (fromIntegral height) (mandelYmin basePoint) (mandelYmax basePoint)

-- customNormalizePixel :: Fractional f => Point -> f -> Pixel -> Point
customNormalizePixel (a,b) zoom pixel = (newX,newY) where
    (x,y) = location pixel
    newX = normalize (fromIntegral x) 0 (fromIntegral width) (a - gap) (a + gap)
    newY = normalize (fromIntegral y) 0 (fromIntegral height) (b - gap) (b + gap)
    gap = 1 / zoom
    
-- | to create the set we map the mandelbrotFunc over every pixel in the grid
-- mandelbrotSet :: FullFigure
mandelbrotSet = convertGrid $ mapGrid mandelbrotFunc $ buildGrid height width whitePixel

-- specificMandelSet :: Fractional f => Point -> f -> FullFigure
specificMandelSet base zoom = convertGrid $ mapGrid (customMandelFunc base zoom) (buildGrid height width whitePixel)

-- mandelZoom :: Point -> Float -> (Float -> Float) -> Int -> [FullFigure]
mandelZoom _ _ _ 0                      = []
mandelZoom base startzoom zoomFunc iter = (image):(mandelZoom base (zoomFunc startzoom) zoomFunc (iter - 1)) where
    image = specificMandelSet base startzoom