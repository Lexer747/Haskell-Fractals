import DataTypes
import CoreSVG
import Utils
import Shapes
import Constants
import Colouring

infiniSquare = publishFullFigure colouredFractal where
    colouredFractal = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare
    recursiveSquare = recursivePolygon newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    newSquare = [(scale 4 4), (translate 10 10)] |=> square

fibonacci = publishFigure $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400

firstTree = publishFigure finalTree where
    finalTree = centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 15
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 fig = (map (\x -> [(translate 10 (-150)),(scale 0.75 0.75),(rot (-20))] |=> x) fig)
    leaf2 fig = (map (\x -> [(translate 0 (-132)),(scale 0.75 0.75),(rot 20)] |=> x) fig)
    
{- temp func
uncolouredTree = centreFigure $ concat $ concat tree where
    tree = recursiveFigure_adv base treeFunc 8
    base = [[([(scale 0.4 1.4)] |=> square),([(scale 0.7 0.5),(rot 45),(translate (-30) 50)] |=> triangle)]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig)++(leaf3 fig))
    leaf1 fig = (map (\x -> [(translate (-100) (-150)),(scale 0.9 0.8),(rot (-25)),(shear 5 10)] |=> x) fig)
    leaf2 fig = (map (\x -> [(translate (-10) 150),(scale 0.9 0.9),(rot 40)] |=> x) fig)
    leaf3 fig = (map (\x -> [(translate 0 0),(scale 0.9 0.9),(rot 170)] |=> x) fig)
-}
main = firstTree

