module AdvConstants 
(regularPolygon
)where

import DataTypes
import Utils

-- |generic polygon
-- useage: regularPolygon length NumOfSides => Polygon
regularPolygon :: Float -> Int -> Polygon
regularPolygon length sides = (|=>) [(translate length length)] $ rp_help (0,length) angle sides where
    angle = (360 / (fromIntegral sides))


-- regularPolygon length sides = helpFinish blank $ 
    -- (helpStart (length, 0) angle sides) where
        -- angle = 180 - (360 / (fromIntegral sides))
        -- blank = (translate 0 0)

rp_help :: Point -> Float -> Int -> Polygon
rp_help current _ 1 = current:[]
rp_help current angle n = current:
    (rp_help next angle (n-1)) where
        next = transformPoint (rot angle) current
        
-- helpFinish :: Transformation -> Polygon -> Polygon
-- helpFinish _ [] = []
-- helpFinish tr ((x,y):xs) = next:(helpFinish nextTr xs) where
    -- next = transformPoint tr (x,y)
    -- nextTr = (translate x y)