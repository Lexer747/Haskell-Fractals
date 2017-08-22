# Haskell Shapes & Fractals

Currently a simple program which creates pretty shapes in SVG format which can be rendered by 
most browsers. It is mostly a learning program, so i am using the process of writing this program to
learn Haskell.

Core code for generating the SVG was found [here](http://stackoverflow.com/questions/2711002/image-drawing-library-for-haskell)
and inspired me in its simplicity.

## Bounding Box:

Just starting, so my first idea was see if I could find a way to produce the bounding box of a shape. Below is the result.

![BoundingBox](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/c8985d36/Samples/box.svg)

The blue rectangle is created using affine transformations then the grey rectangle is produce by finding the bounding box of the shape.
``` Haskell
boundingBox :: FullFigure
boundingBox = centreFullFigure $ blueSq++greySq where
    greySq = [(greyF,greyL,findBBFullFigure blueSq)]
    blueSq = [(blueF,blueL,[(rot 35),(scale 2 1)] |=> square)]
```

## First Fractal:

![Squares](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/94e93ad6/Samples/infini.svg)

This fractal is created by scaling and rotating a square 1000 times. Its a simple but elegant pattern. To generate this image the following code was executed:

``` Haskell
--best read from bottom up
infiniSquare :: FullFigure
infiniSquare = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare where
    recursiveSquare = recursivePolygon newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    newSquare = [(scale 4 4), (translate 10 10)] |=> square
```

## Fibonacci Spiral:

My favourite kind of spiral, I liked the look of it flairing out as it gets bigger.

![FibonacciSpiral](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/94e93ad6/Samples/fib.svg)

This spiral is also simple to make as it is just a square which rotates as it moves away from its start point.
Because its an SVG zooming in on it shows the detail of the spiral nicely. Its made using the following code below:

``` Haskell
fibonacci :: FullFigure
fibonacci = colourizeFig greyF blueL $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400
```
As you can see its a one liner, but it can be broken up into steps:
* `publishFigure` will simply convert the shape to SVG so we can see it.
* `centreFigure` finds the Bounding box of the shape then translates the whole shape so its bounding box is relative to origin.
* `recursivePolygon` takes the base square and recursively applies the list of transformations to it forming the spiral.

Explaining the `recursivePolygon` function and why it looks so crazy. Seeing the type of `recursivePolygon` makes understanding it easier:

``` Haskell
recursivePolygon :: Polygon -> [Transformation] -> Int -> Figure
```

So it takes a `Polygon` , a list of `Transformation` and an `Int`. Then it spits out a `Figure` , 
hence in the code for this spiral we can analyze the parameters to be as such:

``` Haskell
    Polygon             = ([scale 0.01 0.01] |=> square)
    [Transformation]    = [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))]
    Int                 = 400
```

This should make reading the function easier (hopefully).

##Fractal Tree

A cliche fractal but very pretty non-the-less, once again the advantage of SVG makes zooming very satisfying:

![firstTree](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/94e93ad6/Samples/tree.svg)

This is less simple to make but haskell makes it relatively easy for us. I decided to not do this all on one line but it is definitely possible if you so
desire.

``` Haskell
firstTree :: FullFigure
firstTree = colourizeFig greyF blueL finalTree where
    finalTree = centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 12
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 = map (\x -> [(translate 60 (-100)),(scale 0.75 0.75),(rot (-25))] |=> x)
    leaf2 = map (\x -> [(translate (-47) (-87)),(scale 0.75 0.75),(rot 25)] |=> x)
```

So its a little overwhelming at first, but once again i believe that seeing the type signature for recursiveFigure_adv helps a lot.

``` Haskell
recursiveFigure_adv :: [a] -> (a -> a) -> Int -> [[a]]
```

This function essentially has 3 parameters and returns a `[[a]]`, which is a list 
of list of a. The first parameter is the base shape of the recursive
shape `[a]` or as we know it as `[Figure]`. 
The second parameter is where the complexity is `(a -> a)`. And the 3rd
parameter is the number of iterations to perform `Int`.

Lets focus on the second parameter `(a -> a)` which seems redundant. Take any type and return any type.
But what this is actually doing; Is allowing me to pass a function to recursiveFigure_adv 
which can perform the transformations and rebuild the figure all in one parameter.
Hence explaining what `treeFunc` is doing. It performs a transformation on every polygon in base,
then appends this to another set of transformations. Which is also on every polygon in base.

## Tiling Fractal

Not sure if this is a well known fractal but i like the way it looks so i thought it deserved a place on the readme:

![tiling](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/94e93ad6/Samples/hex.svg)

This is also less simple but not too much of a stretch to get your head around. It uses the same recursive
function as the tree just a slightly different transformation function.

``` Haskell
fullTiling :: FullFigure
fullTiling = fullRNG 19 $ centreFigure $ reverse $ concat $ concat tiling
tiling =  recursiveFigure_adv [[base]] tile_func 6 where
    base = regularPolygon 200 6
    tile_func = (\fig -> (tile 0 fig)++(tile 60 fig)++(tile 120 fig)++(tile 180 fig)++(tile 240 fig)++(tile 300 fig))
    tile r = map (\x -> [(scale 0.5 0.5),(moveEuclidean 400 r)] |=> x)
    
```

`moveEuclidean` is a function allows for a transformation in a direction specified in degrees
that moves the specified number of pixels. This just uses simple trig to do this, its
found in `extraTransformations.hs`.

## Sierpinski Triangle

A classic fractal. Wikipedia article [here](https://en.wikipedia.org/wiki/Sierpinski_triangle)

![Triangle](https://github.com/Lexer747/Haskell-Fractals/blob/master/Samples/sierpinski.svg)

This one is basically a tiling fractal so the code is really similar to the hexagon one above.

``` Haskell 
sierpinski :: FullFigure
sierpinski = colourizeFig greyF blueL $ centreFigure $ transformFigure [(rot 180)] $ concat $ concat $ recursiveFigure_adv [[base]] tile_func 9 where
    base = regularPolygon 300 3
    tile_func = (\fig -> (tile 0 fig)++(tile 120 fig)++(tile 240 fig))
    tile r = map (\x -> [(scale 0.5 0.5),(moveEuclidean 300 r)] |=> x)
```

## Mandelbrot Set

The most famous fractal. This was a completely different procedure to create this since colourizing a coordinate grid
doesn't lend itself to vector graphics. But that didn't stop me!

Honestly though this approach is horribly inefficient and your better off using openGL, but i did it more for the sake of it
and to see if it would even work. 

The picture:  
![mandel](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/94e93ad6/Samples/mandel.svg)  

So as you can see it doesn't look great and when you zoom in it looks even worse. One reason it looks bad is the poor colouring code.
The other reason is that the implementation of the coordinate grid will never lend itself to the SVG format.

## Lets break down the code and have a look:

First the coordinate system, which is made up two key parts:
* The `Pixel` data type, which has a location and a colour

    ```Haskell
    data Pixel = Pixel {location :: (Int,Int),
      colour :: Outline} 
      deriving (Show)
    ```  
* A `Grid` which is a 2D list of `Pixel`

    ```Haskell
    type Grid = [[Pixel]]
    ```
   
Then we have some utility functions for working with a `Grid`

```Haskell
convertGrid :: Grid -> FullFigure
convertGrid = (concat . (map convertCompressRow))

mapGrid :: (Pixel -> Pixel) -> Grid -> Grid
mapGrid = (map . map)

-- |Takes a height and width and a base pixel and returns a grid full with that pixel
buildGrid :: Int -> Int -> Pixel -> Grid
buildGrid 0 _ _             = []
buildGrid height width pix  = row:(buildGrid (height - 1) width nextPix) where
    row = buildRow width pix
    nextPix = Pixel (x,y+1) $ colour pix
    (x,y) = location pix
```

All of these are pretty simple if you have understood everything up to this point.
The only odd thing is `convertCompressRow` which currently doesn't have a definition,
I'll let you look at the source code to get the definition.
That because it doesn't really affect the actual final image.

The most important function is `mapGrid` which is what we will actually use to create
the image. As all we need to do is create a function with type `Pixel -> Pixel` which
makes a pixel the right colour according to the how fast that point diverges 
to infinity.

So now all we need is that function:

```Haskell
mandelbrotFunc :: Pixel -> Pixel
mandelbrotFunc pixel = Pixel (location pixel) representative where
    representative = mandelColour iter
    iter = applyMandel iterations curPoint
    curPoint = normalizePixel pixel
    
iterations :: Int
iterations = 50
```

There are 3 functions here which are not defined and I'll let you look them up if you
so desire [here](Core/Mandelbrot.hs). But the short version of it is that `mandelColour` will take a number of
iterations and convert into a grey-scale colour proportional to the number of 
steps in the function that point could do before diverging. 

`applyMandel` takes a point and actually finds the number of iterations before diverging

`normalizePixel` will take large int Pixel values like `x = 100, y = 100` and scale
it down to within much smaller values so there is more detail.

## Combining it all together:

```Haskell
mandelbrotSet :: FullFigure
mandelbrotSet = convertGrid $ mapGrid mandelbrotFunc $ buildGrid height width whitePixel
```

This code will actually build the image by first initializing a grid:

```Haskell
buildGrid height width whitePixel

height :: Int
height = 480
width :: Int
width = 640

whitePixel :: Pixel
whitePixel = Pixel (0,0) (255,255,255)
```

Then map the function over the grid:

```Haskell
mapGrid mandelbrotFunc (grid)
```

Then make it an SVG useable type:
```Haskell
convertGrid (mandelbrot grid)
```

And when we pass this result to `publishFigure` we get the image at the top. The reason
it looks so bad is because when a pixel is converted into SVG it is done so by this
function:

```Haskell
convertPixel :: Pixel -> FullPolygon
convertPixel p = (fill, outline, [(translate (fromIntegral x) (fromIntegral y))] |=> basePixel ) where
    (x,y) = location p
    fill = o2F $ colour p
    outline = colour p 
 
basePixel :: Polygon
basePixel = [(0,0),(1,0),(1,1),(0,1)]
```

Hence each pixel is its own fully rendered Square! This means the SVG engine is working
serious overtime to convert a 640 x 480 pixel grid which will require 307,200 individual
squares to be drawn! Not efficient at all. 

The `convertCompressRow` helps a bit as that joins some of the pixels together into a
large rectangle but its still not great.

I need to implement some better compression techniques before going any higher 
resolution than 480p.

## Author

Code written by Alex Lewis
