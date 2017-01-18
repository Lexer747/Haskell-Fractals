module CoreSVG
(writePoint
,writePolygon
,writeFullPolygon
,writeFullFigure
,writeFullFigurePublish
,colorizeFig
,findBBFigure
,findBBPolygon
) where

import DataTypes
import Data.Char (toUpper)
import Numeric (showHex)

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


writeFullFigurePublish :: FullFigure -> String
writeFullFigurePublish p = "<svg height=\""++height++"\" width=\""++width++"\" xmlns=\"http://www.w3.org/2000/svg\">"++(concatMap writeFullPolygon p)++"</svg>" where
    (x,y) = (findCanvasFull p)
    height = (show x)
    width = (show y)
    
findCanvasFull :: FullFigure -> Point
findCanvasFull fig = (findBBFigure $ fullFigtoFig fig) !! 2

fullFigtoFig :: FullFigure -> Figure
fullFigtoFig [] = []
fullFigtoFig ((_,_,poly):xs) = poly:(fullFigtoFig xs)

writeHex :: Int -> String
writeHex x = map toUpper (showHex x "")

colorizeFig :: Fill -> Colour -> Figure -> FullFigure
colorizeFig fill line fig = zip3 (repeat fill) (repeat line) fig

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