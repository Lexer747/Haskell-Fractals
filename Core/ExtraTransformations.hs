module ExtraTransformations
(moveEuclidean
) where


import DataTypes
import Utils (translate)

moveEuclidean :: Float -> Float -> Transformation
moveEuclidean dis theata = (translate x y) where
    x = (sin angle) * dis
    y = (cos angle) * dis
    angle = theata * (pi / 180)