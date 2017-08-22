module CoordinateSystem (
Pixel(..)
,Grid
,whitePixel
,convertPixel
,convertGrid
,mapGrid
,buildGrid
,mergeGrid
) where

import DataTypes
import Utils

data Pixel = Pixel {location :: (Int,Int),
    colour :: Outline} 
    deriving (Show)
             
basePixel :: Polygon
basePixel = [(0,0),(1,0),(1,1),(0,1)]

whitePixel :: Pixel
whitePixel = Pixel (0,0) (255,255,255)

convertPixel :: Pixel -> FullPolygon
convertPixel p = (fill, outline, [(translate (fromIntegral x) (fromIntegral y))] |=> basePixel ) where
    (x,y) = location p
    fill = o2F $ colour p
    outline = colour p 

type Row = [Pixel]


convertRow :: Row -> FullFigure
convertRow = map convertPixel

buildRow :: Int -> Pixel -> Row
buildRow 0 _        = []
buildRow length pix = pix:(buildRow (length - 1) nextPix) where
    nextPix = Pixel (x+1,y) $ colour pix
    (x,y) = location pix


data MultiPixel = MultiPixel {locationM :: (Int,Int), size :: (Int,Int), colourM :: Outline} deriving (Show)

compressRow :: Row -> [MultiPixel]
compressRow []      = []
compressRow (r:rs)  = compressRow_help (r:rs) (multi r)

compressRow_help :: Row -> MultiPixel -> [MultiPixel]
compressRow_help []          cur  = cur:[]
compressRow_help (pixel:xs) cur  = 
    if (colour pixel) == (colourM cur)
        then (compressRow_help xs next)
        else cur:(compressRow_help xs (multi pixel)) where
            next = MultiPixel (locationM cur) ((x+1),y) (colourM cur)
            (x,y) = (size cur)
        
multi :: Pixel -> MultiPixel
multi pixel = MultiPixel (location pixel) (1,1) (colour pixel)

convertMultiPixel :: MultiPixel -> FullPolygon
convertMultiPixel p = (fill,outline, 
    [(translate (fromIntegral x) (fromIntegral y)),(scale (fromIntegral w) (fromIntegral h))] |=> basePixel) where
        (x,y) = locationM p
        (w,h) = size p
        fill = o2F $ colourM p
        outline = colourM p
       
convertCompressRow :: Row -> FullFigure
convertCompressRow = ((map convertMultiPixel) . compressRow)

type Grid = [[Pixel]]

convertGrid :: Grid -> FullFigure
convertGrid = (concat . (map convertCompressRow))

mapGrid :: (Pixel -> Pixel) -> Grid -> Grid
mapGrid = (map . map) --this is actually amazing, this syntax is crazy

-- |Takes a height and width and a base pixel and returns a grid full with that pixel
buildGrid :: Int -> Int -> Pixel -> Grid
buildGrid 0 _ _             = []
buildGrid height width pix  = row:(buildGrid (height - 1) width nextPix) where
    row = buildRow width pix
    nextPix = Pixel (x,y+1) $ colour pix
    (x,y) = location pix
    
mergeGrid :: [Grid] -> Int -> Grid
mergeGrid (x:[]) _ = x
mergeGrid (x:xs) gap = combineGrid x (mergeGrid xs gap) gap


combineGrid :: Grid -> Grid ->  Int -> Grid
combineGrid xs ys gap = combineGrid_help xs ys width where
    width = x + gap
    (x,y) = largest xs 0 0

largest :: Grid -> Int -> Int -> (Int, Int)
largest [] curX curY = (curX,curY)
largest ([]:rs) curX curY = largest rs curX curY 
largest ((p:ps):rs) curX curY = let (x,y) = location p in
    largest ((ps):rs) (max curX x) (max curY y)
    
combineGrid_help :: Grid -> Grid -> Int -> Grid
combineGrid_help [] [] _                 = []
combineGrid_help (row1:xs) [] x          = (row1):(combineGrid_help xs [] x)
combineGrid_help [] (row2:ys) x          = (shifted x row2):(combineGrid_help [] ys x)
combineGrid_help (row1:xs) (row2:ys) x   = (row1++(shifted x row2)):(combineGrid_help xs ys x)

shifted :: Int -> Row -> Row
shifted newX r = map (\ p -> let (x,y) = (location p) in Pixel ((x + newX), y) (colour p)) r

