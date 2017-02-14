module Constants where

import DataTypes

--constant for the stroke-width of the any svg string made
strokewidth = 0.1

-- |generic line colour
blueL :: Outline
blueL = (0,0,255)
greyL :: Outline
greyL = (238,238,238)

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
-- useage: ellipse (radius-x, radius-y) acurracy => ellipse
-- accuracy -> larger = less accurate
ellipse :: (Float, Float) -> Float -> Polygon
ellipse (xradius,yradius) accuracy = (zip xs $ map y xs)++(zip (reverse xs) $ reverse $ map (\x -> (-1) * (y x)) xs) where
    xs = [(xradius),((xradius) - accuracy)..(-(xradius))] 
    -- ^ create a list of all the x points of the ellipse, the number of points is determined by accuracy
    y x = sqrt((yradius ^ 2) - (((yradius ^ 2) * (x ^ 2)) / (xradius ^ 2)))
    -- find the y value from the x

-- |generic SemiCircle
-- useage: semiCircle radius accuracy => semiCircle
semiCircle :: Float -> Float -> Polygon
semiCircle radius accuracy = zip xs $ map y xs where
    xs = [(radius),(radius - accuracy)..(-radius)]
    y x = sqrt $ (radius ^ 2) - (x ^ 2)
    
-- |blue square
blueSquare :: FullPolygon
blueSquare = (blueF, blueL, square)