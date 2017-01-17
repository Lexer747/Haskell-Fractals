import Numeric (showHex)
import Data.Char (toUpper)


type Colour         = (Int,Int,Int) --line colour of a shape
type Fill           = (Int,Int,Int,Int,Int,Int)
type Point          = (Float, Float) --generic point of polygon
type Polygon        = [Point] --generic shape
-- ^^^ORDER MATTERS!!^^^
type Figure         = [Polygon] --a figure contains a list of shapes
type FullPolygon    = (Fill, Colour, Polygon) --a fully coloured shape
type FullFigure     = [FullPolygon] --a FullFigure is a list of fully coloured shapes
type Transformation = (Float, Float, Float, Float, Float, Float) --an afine transformation matrix

--useage: writePoint Point => svg String
writePoint :: Point -> String 
writePoint (x,y) = (show x)++","++(show y)++" "

--useage: writePolygon (Colour,Polygon) => svg String
writePolygon :: (Colour,Polygon) -> String 
writePolygon ((r,g,b),p) = "<polygon points=\""++(concatMap writePoint p)++"\" style=\"fill:#cccccc;stroke:rgb("++(show r)++","++(show g)++","++(show b)++");stroke-width:2\"/>"

writeFullPolygon :: FullPolygon -> String
writeFullPolygon ((x1,x2,x3,x4,x5,x6),(r,g,b),p) = 
    "<polygon points=\""++(concatMap writePoint p)++"\" style=\"fill:#"++(f)++";stroke:rgb("++(show r)++","++(show g)++","++(show b)++");stroke-width:2\"/>" where
    f = (writeHex x1)++(writeHex x2)++(writeHex x3)++(writeHex x4)++(writeHex x5)++(writeHex x6)

--useage: writeFullFigure FullFigure => svg String
writeFullFigure :: FullFigure -> String 
writeFullFigure p = "<svg xmlns=\"http://www.w3.org/2000/svg\">"++(concatMap writeFullPolygon p)++"</svg>"

writeHex :: Int -> String
writeHex x = map toUpper (showHex x "")

colorizeFig :: Fill -> Colour -> Figure -> FullFigure
colorizeFig fill line fig = zip3 (repeat fill) (repeat line) fig


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



findMaxFull :: FullPolygon -> FullPolygon
findMaxFull (f,c,poly) = (f,c,(findMax poly))

findMax :: Polygon -> Polygon
findMax p = findMax_help $ unzip p

findMax_help :: ([Float],[Float]) -> Polygon
findMax_help (x,y) = [(minimum x, minimum y),(minimum x, maximum y), (maximum x, maximum y),(maximum x, minimum y)]
    
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