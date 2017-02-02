module Utils 
(translate
,scale
,rot
,shear
,(|=>)
,transformPoint
,transformFigure
,transformFullPoly
,transformFullFigure
,changeColour
,findBBFigure
,findBBPolygon
,findSizeFigure
,findSizePolygon
,centreFigure
,centreFullFigure
)where

import DataTypes
import CoreSVG (findBBFigure, findBBPolygon)
import Constants

-- |infix transformation for transfroming points
transformPoint :: Transformation -> Point -> Point
transformPoint (a, b, c, p, q, r) (x, y) = ((x * a + y * b + c),(x * p + y * q + r))

translate :: Float -> Float -> Transformation
translate x y = (1,0,x,0,1,y)

scale :: Float -> Float -> Transformation
scale w h = (w,0,0,0,h,0)

rot :: Float -> Transformation
rot theata = (cos x, sin x, 0, -sin x, cos x, 0) where
    x = theata * (pi / 180)

shear :: Float -> Float -> Transformation
shear phi psi = (1,tan x,0,tan y,1,0) where
    x = phi * (pi / 180)
    y = psi * (pi / 180)
    
-- |useage: transformPolygon [list of transformations to do] Polygon -> Polygon
(|=>) :: [Transformation] -> Polygon -> Polygon
(|=>) trList poly = map f poly where
    f = (\point -> foldr transformPoint point trList)

-- |useage: same as transformPolygon except it uses a fully coloured shape
transformFullPoly :: [Transformation] -> FullPolygon -> FullPolygon
transformFullPoly trList (f,c,poly) = (f,c,(trList |=> poly))

-- |applies a list of transformation to a Figure
transformFigure :: [Transformation] -> Figure -> Figure
transformFigure trList = map f where
    f = (\x -> trList |=> x)

transformFullFigure :: [Transformation] -> FullFigure -> FullFigure
transformFullFigure trList = map f where
    f = (\x -> transformFullPoly trList x)

changeColour :: (Fill, Outline) -> FullPolygon -> FullPolygon
changeColour (newF,newC) (_,_,poly) = (newF, newC, poly)

applyColour :: [(Fill,Outline)] -> Figure -> FullFigure
applyColour [] [] = []
applyColour [] xs = []
applyColour ys [] = []
applyColour ((f,o):ys) (p:xs) = (f,o,p):(applyColour ys xs)

-- |finds the area of the boundingbox of a shape
-- useage: findSizePolygon Polygon => area
findSizePolygon :: Polygon -> Float
findSizePolygon p = x * y where
    (x,y) = (findBBPolygon p) !! 2

-- |finds the area of the boundingbox of a figure
-- useage: findSizeFigure Figure => area
findSizeFigure :: Figure -> Float
findSizeFigure p = x * y where
    (x,y) = (findBBFigure p) !! 2

-- |Makes it so that all the points of the figure are > 0
-- hence normally off-screen shapes are now visible
-- useage: centreFigure figure -> (centred figure)
centreFigure :: Figure -> Figure
centreFigure fig = map (trans |=>) fig where
    trans = [(translate (-x) (-y))]
    (x,y) =  head $ findBBFigure fig

centreFullFigure :: FullFigure -> FullFigure
centreFullFigure = (centreFullFigure_help [] [])

centreFullFigure_help :: Figure -> [(Fill,Outline)] -> FullFigure -> FullFigure
centreFullFigure_help accFig accColour [] = applyColour accColour $ centreFigure accFig
centreFullFigure_help accFig accColour ((f,o,p):xs) = 
    centreFullFigure_help (p:accFig) ((f,o):accColour) xs