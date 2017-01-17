type Point          = (Float, Float)
type Colour         = (Int,Int,Int)
type Polygon        = [Point] --ORDER MATTERS!!
type Transformation = (Float, Float, Float, Float, Float, Float)


writePoint :: Point -> String 
writePoint (x,y) = (show x)++","++(show y)++" "

writePolygon :: (Colour,Polygon) -> String 
writePolygon ((r,g,b),p) = "<polygon points=\""++(concatMap writePoint p)++"\" style=\"fill:#cccccc;stroke:rgb("++(show r)++","++(show g)++","++(show b)++");stroke-width:2\"/>"

writePolygons :: [(Colour,Polygon)] -> String 
writePolygons p = "<svg xmlns=\"http://www.w3.org/2000/svg\">"++(concatMap writePolygon p)++"</svg>"

blank :: Colour
blank = (200,200,200)

writePolygonColourless :: Polygon -> String
writePolygonColourless p = writePolygon (blank, p)

writePolygonsColourless :: [Polygon] -> String
writePolygonsColourless p = writePolygons $ colorize blank p

colorize :: Colour -> [Polygon] -> [(Colour,Polygon)] 
colorize = zip.repeat

(%%) :: Point -> Transformation -> Point
(%%) (x, y) (a, b, c, p, q, r) = 
    ((x * a + y * b + c),(x * p + y * q + r))

translate :: Float -> Float -> Transformation
translate x y = (1,0,x,0,1,y)

scale :: Float -> Float -> Transformation
scale w h = (w,0,0,0,h,0)

rot :: Float -> Transformation
rot theata = (cos x, sin x, 0, -sin x, cos x, 0) where
    x = theata * (180 / pi)

shear :: Float -> Float -> Transformation
shear phi psi = (1,tan x,0,tan y,1,0) where
    x = phi * (180 / pi)
    y = psi * (180 / pi)
    
folding acc f [] = acc
folding acc f (x:xs) = folding (f acc x) f xs
    
    
transformPolygon :: [Transformation] -> Polygon -> Polygon
transformPolygon trList poly = map f poly where
    f = (\x -> folding (x) (%%) trList)

    
    
square :: Polygon
square = [(0,0),(0,100),(100,100),(100,0),(0,0)]

outputColourlessShape :: Polygon -> IO ()
outputColourlessShape shape = writeFile "svg/Output.svg" $ writePolygonsColourless [shape]



{-
rainbow@[red,green,blue,yellow,purple,teal] = map colorize [(255,0,0),(0,255,0),(0,0,255),(255,255,0),(255,0,255),(0,255,255)]

t0 = writeFile "tut0.svg" $ writePolygons (blue [[(100,100),(200,100),(200,200),(100,200)],[(200,200),(300,200),(300,300),(200,300)]])

hexagon c r = translateTo c basicHexagon where
  basicHexagon =  top ++ (negate r, 0):bottom 
  top          =  [(r,0),(r * cos 1,(r * sin 1)),(negate (r * cos 1), r * (sin 1))]
  bottom       =  map (\(x,y)->(x,negate y)) (reverse top)

translateTo (x,y) poly = map f poly where f (a,b) = ((a+x),(b+y))


t1 = writeFile "t1.svg" $ writePolygons (blue [hexagon (100,100) 50] )

hexField r n m = let 
     mkHex n = hexagon (1.5*n*(r*2),(r*2)) r
     row n = map mkHex [1..n]
     aRow = row n
  in concat [map (offset (r*x)) aRow |x<-[1..m]]

offset r polys = map (oh r) polys where
  oh r pt@(x,y) = (x+(1.5*r),y+(r*sin 1))

t2 = writeFile "t2.svg" $ writePolygons (blue $ hexField 50 4 5 )
-}