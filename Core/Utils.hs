module Utils 
((%%)
,translate
,scale
,rot
,shear
,transformPolygon
,(|=>)
,transformFigure
,transformFullPoly
,changeColour
,findBBFigure
,findBBPolygon
,findSizeFigure
,findSizePolygon
,outputFullFigure
,publishFullFigure
,publishFigure
,centreFigure
)where
import DataTypes
import CoreSVG
import Constants

--infix transformation for transfroming points
(%%) :: Point -> Transformation -> Point
(%%) (x, y) (a, b, c, p, q, r) = 
    ((x * a + y * b + c),(x * p + y * q + r))

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
    
folding acc f [] = acc
folding acc f (x:xs) = folding (f acc x) f xs
    
--useage: transformPolygon [list of transformations to do] Polygon => Polygon
transformPolygon :: [Transformation] -> Polygon -> Polygon
transformPolygon trList poly = map f poly where
    f = (\x -> folding (x) (%%) trList)
    
(|=>) :: [Transformation] -> Polygon -> Polygon
(|=>) = transformPolygon

--useage: same as above except it uses a fully coloured shape
transformFullPoly :: [Transformation] -> FullPolygon -> FullPolygon
transformFullPoly trList (f,c,poly) = (f,c,(trList |=> poly))

--applies a list of transformation to a Figure
transformFigure :: [Transformation] -> Figure -> Figure
transformFigure trList = map f where
    f = (\x -> trList |=> x)


changeColour :: (Fill, Outline) -> FullPolygon -> FullPolygon
changeColour (newF,newC) (oldF,oldC,poly) = (newF, newC, poly)

--finds the area of the boundingbox of a shape
--useage: findSizePolygon Polygon => area
findSizePolygon :: Polygon -> Float
findSizePolygon p = x * y where
    (x,y) = (findBBPolygon p) !! 2

--finds the area of the boundingbox of a figure
--useage: findSizeFigure Figure => area
findSizeFigure :: Figure -> Float
findSizeFigure p = x * y where
    (x,y) = (findBBFigure p) !! 2

outputFullFigure :: FullFigure -> IO ()
outputFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigure fig

publishFigure :: Figure -> IO ()
publishFigure fig = publishFullFigure $ colourizeFig greyF blueL fig

centreFigure :: Figure -> Figure
centreFigure fig = map (trans |=>) fig where
    trans = [(translate (-x) (-y))]
    (x,y) =  head $ findBBFigure fig

publishFullFigure :: FullFigure -> IO ()
publishFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigurePublish fig