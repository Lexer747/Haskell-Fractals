module Utils 
((%%)
,translate
,scale
,rot
,shear
,transformPolygon
,transformFullPoly
,changeColour
,findBBFigure
,findBBPolygon
,outputFullFigure
,publishFullFigure
,blueF
,blueL
,blueSquare
)where
import DataTypes
import CoreSVG

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
    x = theata -- * (180 / pi)

shear :: Float -> Float -> Transformation
shear phi psi = (1,tan x,0,tan y,1,0) where
    x = phi * (180 / pi)
    y = psi * (180 / pi)
    
folding acc f [] = acc
folding acc f (x:xs) = folding (f acc x) f xs
    
--useage: transformPolygon [list of transformations to do] Polygon => Polygon
transformPolygon :: [Transformation] -> Polygon -> Polygon
transformPolygon trList poly = map f poly where
    f = (\x -> folding (x) (%%) trList)
    
--useage: same as above except it uses a fully coloured shape
transformFullPoly :: [Transformation] -> FullPolygon -> FullPolygon
transformFullPoly trList (f,c,poly) = (f,c,(transformPolygon trList poly))

changeColour :: (Fill, Colour) -> FullPolygon -> FullPolygon
changeColour (newF,newC) (oldF,oldC,poly) = (newF, newC, poly)

--gets the bounding box of figure
--useage: findBBFigure figure => boundingbox
findBBFigure :: Figure -> Polygon
findBBFigure fig = foldr (findBBFigure_help) [] (map findBBPolygon fig)

findBBFigure_help :: Polygon -> Polygon -> Polygon
findBBFigure_help (a:b:c:d:[]) (e:f:g:h:[])  = 
    (minMaxPoint a e):(minMaxPoint b f):(minMaxPoint c g):(minMaxPoint d h):[]

comp :: Float -> Float -> Float
comp x y = if x > y then x else y
minMaxPoint :: Point -> Point -> Point
minMaxPoint (x,y) (z,w) = (comp x z, comp y w)

--gets the boundingbox of a Polygon
--useage: findBBPolygon Polygon => boundingbox
findBBPolygon :: Polygon -> Polygon
findBBPolygon p = findBB_help $ unzip p
findBB_help :: ([Float],[Float]) -> Polygon
findBB_help (x,y) = [(minimum x, minimum y),(minimum x, maximum y), (maximum x, maximum y),(maximum x, minimum y)]



--finds the area of the boundingbox of a shape
--useage: findSize Polygon => area
findSize :: Polygon -> Float
findSize p = x * y where
    (x,y) = (findBBPolygon p) !! 2

findSizeFull :: FullPolygon -> Float
findSizeFull (f,c,poly) = findSize poly

    
--generic line colour
blueL :: Colour
blueL = (0,0,255)

--generic fill colour
blueF :: Fill
blueF = (0,0,0,0,15,15)

--generic square
square :: Polygon
square = [(0,0),(0,100),(100,100),(100,0)]

--blue square
blueSquare :: FullPolygon
blueSquare = (blueF, blueL, square)

outputFullFigure :: FullFigure -> IO ()
outputFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigure fig

publishFullFigure :: FullFigure -> IO ()
publishFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigurePublish fig