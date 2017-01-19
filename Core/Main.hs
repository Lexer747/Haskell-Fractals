import DataTypes
import CoreSVG
import Utils
import Shapes
import Constants

infiniSquare = publishFullFigure colouredFractal where
    colouredFractal = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare
    recursiveSquare = recursivePolygon newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    newSquare = [(scale 4 4), (translate 10 10)] |=> square

fibonacci = publishFigure $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400

firstTree = publishFigure finalTree where
    finalTree = centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 11
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 fig = (map (\x -> [(translate 10 (-160)),(scale 0.75 0.75),(rot (-25))] |=> x) fig)
    leaf2 fig = (map (\x -> [(translate 0 (-140)),(scale 0.75 0.75),(rot 25)] |=> x) fig)
    
main = infiniSquare

