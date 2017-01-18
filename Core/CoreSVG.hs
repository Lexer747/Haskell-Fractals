module CoreSVG
(writePoint
,writePolygon
,writeFullPolygon
,writeFullFigure
,writeFullFigurePublish
,colourizeFig
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
writePolygon ((r,g,b),p) = "<polygon points=\""++(concatMap writePoint p)++"\" style=\"fill:#cccccc;stroke:rgb("++(show r)++","++(show g)++","++(show b)++");stroke-width:1\"/>"

writeFullPolygon :: FullPolygon -> String
writeFullPolygon ((x1,x2,x3,x4,x5,x6),(r,g,b),p) = 
    "<polygon points=\""++(concatMap writePoint p)++"\" style=\"fill:#"++(f)++";stroke:rgb("++(show r)++","++(show g)++","++(show b)++");stroke-width:1\"/>" where
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

colourizeFig :: Fill -> Colour -> Figure -> FullFigure
colourizeFig fill line fig = zip3 (repeat fill) (repeat line) fig

--gets the bounding box of figure
--useage: findBBFigure figure => boundingbox
findBBFigure :: Figure -> Polygon
findBBFigure fig = findBBPolygon $ concat $ (map findBBPolygon fig)


--gets the boundingbox of a Polygon
--useage: findBBPolygon Polygon => boundingbox
findBBPolygon :: Polygon -> Polygon
findBBPolygon p = findBB_help $ unzip p
findBB_help :: ([Float],[Float]) -> Polygon
findBB_help (x,y) = [(minimum x, minimum y),(minimum x, maximum y), (maximum x, maximum y),(maximum x, minimum y)]