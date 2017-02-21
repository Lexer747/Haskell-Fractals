module Mandelbrot where

import CoordinateSystem
import CoreIO
import DataTypes


height :: Int
height = 480
width :: Int
width = 640

iterations :: Int
iterations = 50

zoom :: Float
zoom = 0.75

gap :: Float
gap = 1 / (zoom)

basePoint :: Point
basePoint = ((-0.5),0)

mandelXmin (x,_) = (x - gap)
mandelXmax (x,_) = (x + gap)
mandelYmin (_,y) = (y - gap)
mandelYmax (_,y) = (y + gap)

--customMandelFunc :: Point -> Float -> (Pixel -> Pixel)
customMandelFunc base zoom pixel = Pixel (location pixel) representative where
    representative = mandelColour iter
    iter = applyMandel iterations curPoint 
    curPoint = customNormalizePixel base zoom pixel


mandelbrotFunc :: Pixel -> Pixel
mandelbrotFunc pixel = Pixel (location pixel) representative where
    representative = mandelColour iter
    iter = applyMandel iterations curPoint
    curPoint = normalizePixel pixel


--mandelColour :: (Integral a) => a -> Outline
mandelColour iter = if (fromIntegral iter) == iterations then (0,0,0) else (r,g,b) where
    r = round $ t * ( 1 + sin t) / 1
    g = round $ t * ( 1 + cos t) / 1
    b = round $ t * ( 1 + cos(sin t)) / 1
    t = normalize (sqrt brightness) 0 1 15 255 --240
    brightness = normalize (fromIntegral iter) 0 (fromIntegral iterations) 0 1
    

--applyMandel will take a number of function iterations to do and return how many it managed to perform on a point
applyMandel :: Int -> Point -> Int
applyMandel n (x,y) = n - applyMandel_help n (x,y) (0,0)
    
--applyMandel_help :: (Floating t, Ord t) => Int -> (t,t) -> (t,t) -> Int
applyMandel_help 0 _ _ = 0
applyMandel_help n (baseX,baseY) (x,y) = 
    if  (sqrt $ (newX * newX) + (newY * newY)) > 2
        then n
        else (applyMandel_help (n-1) (baseX,baseY) (newX,newY)) where
            newX = baseX +((x * x) - (y * y))
            newY = baseY + (2 * x * y)


normalize :: Fractional a => a -> a -> a -> a -> a -> a
normalize cur min max newMin newMax = (((newMax - newMin) * (cur - min)) / (max - min)) + newMin

normalizePixel pixel = (newX, newY) where
    (x,y) = location pixel
    newX = normalize (fromIntegral x) 0 (fromIntegral width) (mandelXmin basePoint) (mandelXmax basePoint)
    newY = normalize (fromIntegral y) 0 (fromIntegral height) (mandelYmin basePoint) (mandelYmax basePoint)


--customNormalizePixel :: Fractional t => (t,t) -> t -> Pixel -> (t,t)
customNormalizePixel (a,b) zoom pixel = (newX,newY) where
    (x,y) = location pixel
    newX = normalize (fromIntegral x) 0 (fromIntegral width) (a - gap) (a + gap)
    newY = normalize (fromIntegral y) 0 (fromIntegral height) (b - gap) (b + gap)
    gap = 1 / zoom
    
-- | to create the set we map the mandelbrotFunc over every pixel in the grid
mandelbrotSet :: FullFigure
mandelbrotSet = convertGrid $ mapGrid mandelbrotFunc $ buildGrid height width whitePixel

--specificMandelSet :: Point -> Float -> FullFigure
specificMandelSet base zoom = convertGrid $ mapGrid (customMandelFunc base zoom) (buildGrid height width whitePixel)

--mandelZoom :: Point -> Float -> (Float -> Float) -> Int -> [FullFigure]
mandelZoom _ _ _ 0                      = []
mandelZoom base startzoom zoomFunc iter = (image):(mandelZoom base (zoomFunc startzoom) zoomFunc (iter - 1)) where
    image = specificMandelSet base startzoom