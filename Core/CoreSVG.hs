module CoreSVG
(writeFullPolygon
,writeFullFigure_dep
,writeFullFigure
,colourizeFig
,findBBFigure
,findBBFullFigure
,findBBPolygon
) where 

import DataTypes
import Data.Char (toUpper)
import Numeric (showHex)
import Constants (strokewidth)

{- This function takes a Point and returns a string which is formatted as
an svg point. -}
writePoint :: Point -> String 
writePoint (x,y) = (show x)++","++(show y)++" "

{- useage: writeFullPolygon FullPolygon => svg String
This function takes a tuple of the (Fill, Outline, Polygon) and will
recursively call writePoint on each Point in the Polygon, as Polygon
is a list of Point. Since we will get a list of String from that result
we need to 'flatten' the list into one big string. This could be done by

concat $ map writePoint p

But haskell combines the two into concatMap. Then it adds the Fill 
and Outline to the svg definition of the Polygon. -}
writeFullPolygon :: FullPolygon -> String
writeFullPolygon ((r1,r2,g1,g2,b1,b2),(r,g,b),p) = 
    "    <polygon points=\""++(concatMap writePoint p)++"\" style=\"fill:#"++(f)++";stroke:rgb("++(show r)++","++(show g)++","++(show b)++");stroke-width:"++(show strokewidth)++"\"/>\n" where
    f = (writeHex r1)++(writeHex r2)++(writeHex g1)++(writeHex g2)++(writeHex b1)++(writeHex b2)

{- useage: writeFullFigure FullFigure => svg String
This function takes a list of Full Polygons and maps writeFullPolygon
to each one. Since we will get a list of String from that result we need to
concatenate each element in the list to get the big String we actually need.
Hence why we use concatMap to do so.

It also crucially adds the svg tags and the basic meta data to the string -}
writeFullFigure_dep :: FullFigure -> String 
writeFullFigure_dep p = "<svg xmlns=\"http://www.w3.org/2000/svg\">\n"++(concatMap writeFullPolygon p)++"</svg>"

{- useage: writeFullFigurePublish FullFigure => svg String ready for viewing
Since GitHub's markdown can't display svg unless the height and width
is explicitly stated. This function is essentially writeFullFigure but
also finds the height and width of the figure and writes that to the
svg attributes tag. -}
writeFullFigure :: FullFigure -> String
writeFullFigure f = "<svg height=\""++height++"\" width=\""++width++"\" xmlns=\"http://www.w3.org/2000/svg\">\n"++(concatMap writeFullPolygon f)++"</svg>" where
    (x,y) = (findCanvasFull f)
    height = (show y)
    width = (show x)
    
--This is the function which finds the height and width of a figure
findCanvasFull :: FullFigure -> Point
findCanvasFull fig = (findBBFigure $ fullFigtoFig fig) !! 2

--This function is helper function to strip all the colour out of a figure
fullFigtoFig :: FullFigure -> Figure
fullFigtoFig [] = []
fullFigtoFig ((_,_,poly):xs) = poly:(fullFigtoFig xs)

--Also a helper function for writing the Fill in svg
writeHex :: Int -> String
writeHex x = map toUpper (showHex x [])

{- useage: colourizeFig Fill Outline Figure => FullFigure
this function takes a specified Fill and Outline and creates
a list of tuples holding the (Fill,Outline,Polygon). Note:

repeat x

creates an infinite list of x. Haskell can do this becuase its lazy.
So even though it has infinite colours to zip in theory, once it
reaches the end the Figure list its too 'lazy' to continue. -}
colourizeFig :: Fill -> Outline -> Figure -> FullFigure
colourizeFig fill line fig = zip3 (repeat fill) (repeat line) fig


{- useage: findBBFigure figure => boundingbox
The boundingbox which is returned is always a rectangle. 
It is calculated by 'flattening' all the figures into
one big Polygon, then finding the boundingbox of that shape.
Hence it always a Polygon with 4 elements. [a,b,c,d]

where:

a-----d
|     |
|     |
b-----c
-}
findBBFigure :: Figure -> Polygon
findBBFigure = findBBPolygon . concat 

findBBFullFigure :: FullFigure -> Polygon
findBBFullFigure = findBBFigure . fullFigtoFig

{- useage: findBBPolygon Polygon => boundingbox
Same properties as findBBFigure, execpt its only for one list of Points. 
Since a list of points is a list of Point which is a tuple we can unzip it
into a pair of lists. -}
findBBPolygon :: Polygon -> Polygon
findBBPolygon = findBB_help . unzip 

{- The actual fromula for finding the boundingbox 
It works by receiving a pair of (all x's,all y's) and simply orders
them correctly. -}
findBB_help :: ([Float],[Float]) -> Polygon
findBB_help (x,y) = [(minx, miny),(minx, maxy), (maxx, maxy),(maxx, miny)] where
    minx = minimum x
    maxx = maximum x
    miny = minimum y
    maxy = maximum y