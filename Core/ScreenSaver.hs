import DataTypes
import CoreSVG
import CoreIO
import Utils
import Recursive
import Constants
import Colouring

trunk :: FullFigure
trunk = colourizeFig (8,3,6,9,5,3) (131,105,83) finalTree where
    finalTree = concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 6
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 80 (-90)),(scale 0.75 0.75),(rot (-40))] |=> x)
    leaf2 = map (\x -> [(translate (-33) (-90)),(scale 0.75 0.75),(rot 20)] |=> x)

leaf :: FullFigure
leaf = transformFullFigure [(rot 90), (shear 45 30)] (stem++base) where
    stem = colourizeFig (0,0,6,4,0,0) (0,100,0) [(ellipse (35,0.5) 10)]
    base = colourizeFig (7,7,14,14,7,7) (47,87,47) [(ellipse (40,15) 10)]

grass :: FullFigure
grass = leaf


main = publishFullFigure $ centreFullFigure $ concat [leaf,trunk]
