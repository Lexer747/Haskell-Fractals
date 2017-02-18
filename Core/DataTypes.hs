module DataTypes (
Outline
,Fill
,Point
,Polygon
,Figure
,FullPolygon
,FullFigure
,Transformation
,f2O
,o2F
) where

-- |line colour of a polygon
type Outline         = (Int,Int,Int) 
-- |fill colour of a polygon
type Fill           = (Int,Int,Int,Int,Int,Int) 

-- |generic point of on a polygon
type Point          = (Float, Float)
-- |generic polygon
type Polygon        = [Point]
-- |list of polygons
type Figure         = [Polygon]

-- |
type FullPolygon    = (Fill, Outline, Polygon) --a fully coloured shape
type FullFigure     = [FullPolygon] --a FullFigure is a list of fully coloured shapes

type Transformation = (Float, Float, Float, Float, Float, Float) --an afine transformation matrix

f2O :: Fill -> Outline
f2O (a,b,c,d,e,f) = (((a * 16) + b),((c * 16) + d),((e * 16) + f))

o2F :: Outline -> Fill
o2F (r,g,b) = ((r // 16),(r `mod` 16),(g // 16),(g `mod` 16),(b // 16),(b `mod` 16))

(//) = div

