import DataTypes
import CoreSVG
import CoreIO
import Utils
import Recursive
import Constants

depth :: Int
depth = 9

brownF = (11,8,7,3,3,3)
brownO = (184,115,51)

greenF = (10,14,15,15,2,15)
greenO = (173,255,47)

skyBlueF = (8,7,12,14,14,11)
skyBlueO = (135,206,235)

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
    base = [ transformFigure [(scale 1 1),(translate (-13) (2))] [ ([(rot (-30)),(translate (-20) (-15))] |=> leaf),
        ([(rot 30),(translate 70 (10))] |=> leaf),
        ([(rot 120),(translate (30) (25))] |=> leaf),
        ([(rot 70),(translate (50) (25))] |=> leaf)]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 80 (-90)),(scale 0.75 0.75),(rot (-40))] |=> x)
    leaf2 = map (\x -> [(translate (-33) (-90)),(scale 0.75 0.75),(rot 20)] |=> x)

finalTree :: FullFigure
finalTree = reverse $
    transformFullFigure [(scale 1.5 2), (translate 300 820)] $
    remove (greenF,greenO) ((leafyTree)++(trunk)) (((2 ^ depth) * 3) // 7)

canvas :: Polygon
canvas = [(0,0),(1080,0),(1080, 1920),(0,1920)]

blueSky :: FullFigure
blueSky = colourizeFig skyBlueF skyBlueO [canvas]

grass :: FullFigure
grass = colourizeFig greenF greenO $ [ [(translate 0 1767),(scale 1 0.08) ] |=> canvas]

cloud1 :: Figure
cloud1 = transformFigure [(rot 180)] [
    (semiCircle 100 5),
    ([(scale 1 1.3),(translate 230 0)] |=> (semiCircle 200 5)),
    ([(translate 550 0)] |=> (semiCircle 200 5))]

cloud2 :: Figure
cloud2 = transformFigure [(rot 180),(translate 500 450)] [
    (semiCircle 150 5),
    ([(scale 1 1.3),(translate 220 0)] |=> (semiCircle 130 5)),
    ([(translate 540 0)] |=> (semiCircle 310 5)),
    ([(scale 1 1.4),(translate 810 0)] |=> (semiCircle 180 5))]
    
cloudCluster :: FullFigure
cloudCluster = colourizeFig (15,15,15,15,15,15) (255,255,255) $ 
    transformFigure [(translate 1000 650),(scale 0.8 0.8)] $ cloud1++cloud2

main = publishFullFigure $ blueSky++cloudCluster++grass++finalTree
