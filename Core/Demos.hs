import DataTypes
import CoreSVG
import CoreIO
import Utils
import Recursive
import Constants
import AdvConstants
import Colouring
import ExtraTransformations

--change this to decide where the output svg files go.
folder :: String
folder = "Samples/"

boundingBox :: FullFigure
boundingBox = centreFullFigure $ blueSq++greySq where
    greySq = [(greyF,greyL,findBBFullFigure blueSq)]
    blueSq = [(blueF,blueL,[(rot 35),(scale 2 1)] |=> square)]

infiniSquare :: FullFigure
infiniSquare = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare where
    recursiveSquare = recursivePolygon newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    newSquare = [(scale 4 4), (translate 10 10)] |=> square

fibonacci :: FullFigure
fibonacci = colourizeFig greyF blueL $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400

firstTree :: FullFigure
firstTree = colourizeFig greyF blueL finalTree where
    finalTree = centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 12
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 60 (-100)),(scale 0.75 0.75),(rot (-25))] |=> x)
    leaf2 = map (\x -> [(translate (-47) (-87)),(scale 0.75 0.75),(rot 25)] |=> x)
    
fullTiling :: FullFigure
fullTiling = fullRNG 19 $ centreFigure $ reverse $ concat $ concat tiling
tiling =  recursiveFigure_adv [[base]] tile_func 6 where
    base = regularPolygon 200 6
    tile_func = (\fig -> (tile 0 fig)++(tile 60 fig)++(tile 120 fig)++(tile 180 fig)++(tile 240 fig)++(tile 300 fig))
    tile r = map (\x -> [(scale 0.5 0.5),(moveEuclidean 400 r)] |=> x)
    
sierpinski :: FullFigure
sierpinski = colourizeFig greyF blueL $ centreFigure $ transformFigure [(rot 180)] $ concat $ concat $ recursiveFigure_adv [[base]] tile_func 9 where
    base = regularPolygon 300 3
    tile_func = (\fig -> (tile 0 fig)++(tile 120 fig)++(tile 240 fig))
    tile r = map (\x -> [(scale 0.5 0.5),(moveEuclidean 300 r)] |=> x)
    
flower :: FullFigure
flower = colourizeFig greyF blueL $ centreFigure $ concat $ recursiveTransform base transFunc trList changeTrs 5000 where
    base = [regularPolygon 300 3]
    trList = [(scale 0.999 0.999),(rot 10)]
    changeTrs = changeTr (rot 10) 
    transFunc tr = (|=>) tr  
    
changeTr :: Transformation -> [Transformation] -> [Transformation]
changeTr plus (x:xs) = (combineTransformation plus x):xs
changeTr _ [] = []
    
main = do  
    putStrLn "Starting..."
    putStrLn "boundingBox:      started"
    namedPublish (folder++"box") boundingBox
    putStrLn "infiniSquare:     started"
    namedPublish (folder++"infini") infiniSquare
    putStrLn "fibonacci:        started"
    namedPublish (folder++"fib") fibonacci
    putStrLn "tree:             started"
    namedPublish (folder++"tree") firstTree
    putStrLn "hexagons:         started"
    namedPublish (folder++"hex") fullTiling
    putStrLn "sierpinski:       started"
    namedPublish (folder++"sierpinski") sierpinski
    putStrLn "flower:           started"
    namedPublish (folder++"flower") flower
    putStrLn "Finished..."
    
    
    
    
    

-- customTree :: Fill -> Outline -> Int -> Float -> Float -> FullFigure
-- customTree fill outline branches scl rt = finalTree where
    -- finalTree = colourizeFig fill outline $ centreFigure $ concat $ concat tree
    -- tree = recursiveFigure_adv base treeFunc branches
    -- base = [[[(scale 0.4 1.4)] |=> square]]
    -- treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    -- leaf1 = map (\x -> [(translate 14 (-140)),(scale (scl) (scl)),(rot (-rt))] |=> x)
    -- leaf2 = map (\x -> [(translate 14 (-140)),(scale (scl) (scl)),(rot (rt))] |=> x)
-- main = do
    -- putStrLn "Fill Colour? "
    -- fillList <- getInts 6
    -- putStrLn "Outline Colour? "
    -- outlineList <- getInts 3
    -- putStr "Number of branches? "
    -- branches <- getInt
    -- putStr "scaling Factor? "
    -- scl <- getFloat
    -- putStr "angle? "
    -- rt <- getFloat
    -- let tree = customTree (r1,r2,g1,g2,b1,b2) (r,g,b) branches scl rt 
        -- r1:r2:g1:g2:b1:b2:_ = fillList
        -- r:g:b:_ = outlineList
    -- publishFullFigure tree
    -- putStrLn "Success!"

