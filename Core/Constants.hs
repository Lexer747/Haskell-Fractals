module Constants 
(blueL
,blueF
,greyF
,square
,blueSquare
)where

import DataTypes


--generic line colour
blueL :: Colour
blueL = (0,0,255)

--generic fill colour
blueF :: Fill
blueF = (0,0,0,0,15,15)
greyF :: Fill
greyF = (14,14,14,14,14,14)

--generic square
square :: Polygon
square = [(0,0),(0,100),(100,100),(100,0)]

--blue square
blueSquare :: FullPolygon
blueSquare = (blueF, blueL, square)