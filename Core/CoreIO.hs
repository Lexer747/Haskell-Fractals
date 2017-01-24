module CoreIO
(getInt
,getInts
,getFloat
,publishFullFigure_dep
,publishFullFigure
)where

import DataTypes
import CoreSVG (writeFullFigure_dep,writeFullFigure)
import Control.Monad (replicateM)

-- |A function which takes a FullFigure and writes it to a file
publishFullFigure_dep :: FullFigure -> IO ()
publishFullFigure_dep fig = writeFile "svg/Output.svg" $ writeFullFigure_dep fig

-- |A function which takes a FullFigure and writes it to a file so it is viewable
-- useage: publishFullFigure figureToView => ()
publishFullFigure :: FullFigure -> IO ()
publishFullFigure fig = writeFile "svg/Output.svg" $ writeFullFigure fig

-- |A function which takes a number which defines the number of ints to get from the cmdLine
getInts :: Int -> IO [Int]
getInts n = fmap (fmap read) $ mapM (const getLine) [1.. n]

-- |gets a single int from the cmdLine
getInt :: IO Int
getInt = fmap read getLine

-- |gets a single Float from the cmdLine
getFloat :: IO Float
getFloat = fmap read getLine
