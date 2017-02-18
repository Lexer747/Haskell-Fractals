module CoordinateSystem (
Pixel
,Grid
,whitePixel
,convertPixel
,convertGrid
,mapGrid
,buildGrid
) where

import DataTypes
import Utils

data Pixel = Pixel {location :: (Int,Int), colour :: Outline} deriving (Show)
             
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
buildRow 0 _ = []
buildRow length pix = pix:(buildRow (length - 1) nextPix) where
    nextPix = Pixel (x+1,y) $ colour pix
    (x,y) = location pix

type Grid = [Row]

convertGrid :: Grid -> FullFigure
convertGrid = (concat . (map convertRow))

mapGrid :: (Pixel -> Pixel) -> Grid -> Grid
mapGrid = (map . map) --this is actually amazing, this syntax is crazy

-- |Takes a height and width and a base pixel and returns a grid full with that pixel
buildGrid :: Int -> Int -> Pixel -> Grid
buildGrid 0 _ _ = []
buildGrid height width pix = row:(buildGrid (height - 1) width nextPix) where
    row = buildRow width pix
    nextPix = Pixel (x,y+1) $ colour pix
    (x,y) = location pix

