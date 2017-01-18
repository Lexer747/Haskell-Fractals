import DataTypes
import CoreSVG
import Utils
import Shapes

infiniSquare = publishFullFigure colouredFractal where
    colouredFractal = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare
    recursiveSquare = recursiveFigure newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    newSquare = transformPolygon [(scale 4 4), (translate 10 10)] square

--TODO: cmd line arguments to allow shape drawing
main = putStrLn $ writeFullFigure [blueSquare]

