import DataTypes
import CoreSVG
import CoreIO
import Utils
import Recursive
import Constants
import Colouring

depth :: Int
depth = 18

brownF = (8,3,6,9,5,3)
brownO = (131,105,83)

greenF = (7,7,14,14,7,7)
greenO = (119,221,119)

(//) = div

remove :: (Fill,Outline) -> FullFigure -> Int -> FullFigure
remove _ [] _ = []
remove _ xs 0 = xs
remove (targetF, targetO) ((f,o,p):xs) n = 
    if (targetF == f) && (targetO == o)
        then remove (targetF,targetO) xs (n-1)
        else (f,o,p):(remove (targetF, targetO) xs n)

trunk :: FullFigure
trunk = colourizeFig brownF brownO finalTree where
    finalTree = concat $ concat tree
    tree = recursiveFigure_adv base treeFunc depth
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 80 (-90)),(scale 0.75 0.75),(rot (-40))] |=> x)
    leaf2 = map (\x -> [(translate (-33) (-90)),(scale 0.75 0.75),(rot 20)] |=> x)

leafyTree :: FullFigure
leafyTree = colourizeFig greenF greenO $ concat $ concat tree where
    tree = recursiveFigure_adv base treeFunc depth
    leaf = (ellipse (40,10) 10)
    base = [ transformFigure [(scale 1 1),(translate (-13) (2))] [ ([(rot (-30)),(translate (-20) (-15))] |=> leaf), ([(rot 30),(translate 70 (10))] |=> leaf), ([(rot 120),(translate (30) (25))] |=> leaf), ([(rot 70),(translate (50) (25))] |=> leaf)]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 80 (-90)),(scale 0.75 0.75),(rot (-40))] |=> x)
    leaf2 = map (\x -> [(translate (-33) (-90)),(scale 0.75 0.75),(rot 20)] |=> x)

finalTree :: FullFigure
finalTree = remove (greenF,greenO) ((leafyTree)++(trunk)) (((2 ^ depth) * 3) // 20)

main = publishFullFigure $ centreFullFigure finalTree
