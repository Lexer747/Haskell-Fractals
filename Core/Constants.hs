module Constants 
(blueL
,blueF
,greyF
,square
,triangle
,ellipse
,blueSquare
)where

import DataTypes

-- |generic line colour
blueL :: Outline
blueL = (0,0,255)

-- |generic fill colour
blueF :: Fill
blueF = (0,0,0,0,15,15)
greyF :: Fill
greyF = (14,14,14,14,14,14)

-- |generic square
square :: Polygon
square = [(0,0),(0,100),(100,100),(100,0)]

-- |generic triangle
triangle :: Polygon
triangle = [(100,0),(0,100),(100,100)]

-- |generic Ellipse
-- useage: ellipse radius numberOfIterations startx => ellipse
ellipse :: (Float, Float) -> Float -> Polygon
ellipse (xradius,yradius) accuracy = (zip xs $ map y xs)++(zip (reverse xs) $ reverse $ map (\x -> (-1) * (y x)) xs) where
    xs = [(xradius),((xradius) - accuracy)..(-(xradius))]
    y x = sqrt((yradius ^ 2) - (((yradius ^ 2) * (x ^ 2)) / (xradius ^ 2)))

-- |blue square
blueSquare :: FullPolygon
blueSquare = (blueF, blueL, square)