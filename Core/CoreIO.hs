module CoreIO
(getInt
,getInts
,getFloat
,outputFullFigure
,publishFullFigure
)where

import DataTypes
import CoreSVG (writeFullFigure,writeFullFigurePublish)
import Control.Monad (replicateM)

outputFullFigure :: FullFigure -> IO ()
outputFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigure fig

publishFullFigure :: FullFigure -> IO ()
publishFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigurePublish fig

getInts :: Int -> IO [Int]
getInts n = fmap (fmap read) $ mapM (const getLine) [1.. n]

getInt :: IO Int
getInt = fmap read getLine

getFloat :: IO Float
getFloat = fmap read getLine
