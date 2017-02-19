module CoreIO
(getInt
,getInts
,getFloat
,publishFullFigure_dep
,publishFullFigure
,namedPublish
,multiNamePublish
)where

import DataTypes
import CoreSVG (writeFullFigure_dep,writeFullFigure)
import Control.Monad (replicateM)

-- |A function which takes a FullFigure and writes it to a file
publishFullFigure_dep :: FullFigure -> IO ()
publishFullFigure_dep fig = writeFile "Output.svg" $ writeFullFigure_dep fig

-- |A function which takes a FullFigure and writes it to a file so it is viewable
-- useage: publishFullFigure figureToView => ()
publishFullFigure :: FullFigure -> IO ()
publishFullFigure fig = writeFile "Output.svg" $ writeFullFigure fig

namedPublish :: String -> FullFigure -> IO ()
namedPublish file fig = writeFile (file++".svg") $ writeFullFigure fig

multiNamePublish_help :: String -> Int -> [FullFigure] -> IO ()
multiNamePublish_help file num (f:[])        = namedPublish (file++(show num)) f
multiNamePublish_help file num (f:xs)       = do 
    namedPublish (file++(show num)) f
    multiNamePublish_help file (num + 1) xs

-- |A function which will convert a list of related full figures to a series of numbered svg files
multiNamePublish :: String -> [FullFigure] -> IO ()
multiNamePublish file figs = multiNamePublish_help file 0 figs

-- |A function which takes a number which defines the number of ints to get from the cmdLine
getInts :: Int -> IO [Int]
getInts n = fmap (fmap read) $ mapM (const getLine) [1.. n]

-- |gets a single int from the cmdLine
getInt :: IO Int
getInt = fmap read getLine

-- |gets a single Float from the cmdLine
getFloat :: IO Float
getFloat = fmap read getLine
