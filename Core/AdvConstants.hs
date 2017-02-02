module AdvConstants 
(regularPolygon
)where

import DataTypes
import Utils

-- |generic polygon
-- useage: regularPolygon length NumOfSides => Polygon
regularPolygon :: Float -> Int -> Polygon
regularPolygon length sides = rp_help (0,length) angle sides where
    angle = (360 / (fromIntegral sides))

rp_help :: Point -> Float -> Int -> Polygon
rp_help current _ 1 = current:[]
rp_help current angle n = current:
    (rp_help next angle (n-1)) where
        next = transformPoint (rot angle) current