module CoreSVG
(writePoint
,writePolygon
,writeFullPolygon
,writeFullFigure
,writeFullFigurePublish
,colorizeFig
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
findCanvasFull xs = findCanvas (map (\(_,_,poly) -> findCanvas poly) xs)

findCanvas :: Polygon -> Point
findCanvas p = findCanvas_help $ unzip p

findCanvas_help :: ([Float],[Float]) -> Point
findCanvas_help (x,y) = (maximum x, maximum y)

writeHex :: Int -> String
writeHex x = map toUpper (showHex x "")

colorizeFig :: Fill -> Colour -> Figure -> FullFigure
colorizeFig fill line fig = zip3 (repeat fill) (repeat line) fig