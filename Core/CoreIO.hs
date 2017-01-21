module CoreIO
(getInt
)where

getInt :: IO Int
getInt = fmap read getLine
