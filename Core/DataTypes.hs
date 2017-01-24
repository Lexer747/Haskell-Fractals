module DataTypes where

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