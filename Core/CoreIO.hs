module CoreIO
(getInt
,getInts
,getFloat
,publishFullFigureDefualtColour
,publishFullFigure
)where

import DataTypes
import CoreSVG (writeFullFigure_dep,writeFullFigure)
import Control.Monad (replicateM)

publishFullFigureDefualtColour :: FullFigure -> IO ()
publishFullFigureDefualtColour fig = writeFile "svg/Output.svg" $ writeFullFigure_dep fig

publishFullFigure :: FullFigure -> IO ()
publishFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigure fig

getInts :: Int -> IO [Int]
getInts n = fmap (fmap read) $ mapM (const getLine) [1.. n]

getInt :: IO Int
getInt = fmap read getLine

getFloat :: IO Float
getFloat = fmap read getLine
