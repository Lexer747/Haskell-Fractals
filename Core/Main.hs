import DataTypes
import CoreSVG
import CoreIO
import Utils
import Recursive
import Constants
import Colouring

infiniSquare = publishFullFigure colouredFractal where
    colouredFractal = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare
    recursiveSquare = recursivePolygon newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    newSquare = [(scale 4 4), (translate 10 10)] |=> square

fibonacci = publishFullFigure $ colourizeFig greyF blueL $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400

firstTree = publishFullFigure $ colourizeFig greyF blueL finalTree where
    finalTree = centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 10
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 14 (-140)),(scale 0.75 0.75),(rot (-20))] |=> x)
    leaf2 = map (\x -> [(translate 0 (-140)),(scale 0.75 0.75),(rot 20)] |=> x)

customTree :: Fill -> Outline -> Int -> Float -> Float -> FullFigure
customTree fill outline branches scl rt = finalTree where
    finalTree = colourizeFig fill outline $ centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc branches
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 14 (-140)),(scale (scl) (scl)),(rot (-rt))] |=> x)
    leaf2 = map (\x -> [(translate 14 (-140)),(scale (scl) (scl)),(rot (rt))] |=> x)
    
main = do
    putStrLn "Fill Colour? "
    fillList <- getInts 6
    putStrLn "Outline Colour? "
    outlineList <- getInts 3
    putStr "Number of branches? "
    branches <- getInt
    putStr "scaling Factor? "
    scl <- getFloat
    putStr "angle? "
    rt <- getFloat
    let tree = customTree (r1,r2,g1,g2,b1,b2) (r,g,b) branches scl rt 
        r1:r2:g1:g2:b1:b2:_ = fillList
        r:g:b:_ = outlineList
    publishFullFigure tree
    putStrLn "Success!"

