module ExtraTransformations where


import DataTypes
import Utils (translate)

moveEuclidean :: Float -> Float -> Transformation
moveEuclidean dis theata = (translate x y) where
    x = (sin angle) * dis
    y = (cos angle) * dis
    angle = theata * (pi / 180)
    
combineTransformation :: Transformation -> Transformation -> Transformation
combineTransformation   (x01,x02,x03,
                         y01,y02,y03)
                        (x11,x12,x13,
                         y11,y12,y13) = 
                            (x01 * x11 + x02 * y11 + x03, x01 * x12 + x02 * y12 + x03, x01 * x13 + x02 * y13 + x03,
                            y01 * x11 + y02 * y11 + y03, y01 * x12 + y02 * y12 + y03, y01 * x13 + y02 * y13 + y03)