module DataTypes where

type Outline         = (Int,Int,Int) --line colour of a shape
type Fill           = (Int,Int,Int,Int,Int,Int)
type Point          = (Float, Float) --generic point of polygon
type Polygon        = [Point] --generic shape
-- ^^^ORDER MATTERS!!^^^
type Figure         = [Polygon] --a figure contains a list of shapes
type FullPolygon    = (Fill, Outline, Polygon) --a fully coloured shape
type FullFigure     = [FullPolygon] --a FullFigure is a list of fully coloured shapes
type Transformation = (Float, Float, Float, Float, Float, Float) --an afine transformation matrix