# Haskell Shapes & Fractals
Currently a simple program which creates pretty shapes in svg format which can be rendered by 
most browsers. It is mostly a learning program, so i am using the process of writing this program to
learn Haskell.

Core code for generating the svg was found [here](http://stackoverflow.com/questions/2711002/image-drawing-library-for-haskell)
and inspired me in its simplicty.

## Sample images:

###Bounding Box:

Just starting, so my first idea was see if I could find a way to produce the bouding box of a shape. Below is the result.

![BoundingBox](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/ccc9f170/Core/svg/BoundingBox_Demo.svg)

The blue rectangle is created using affine transformations then the grey rectangle is produce by finding the bouding box of the shape.

---

###First Fractal:

![Squares](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/8650b7e6/Core/svg/InfiniteSquares_Demo.svg)

This fractal is created by scaling and rotating a square 1000 times. Its a simple but elegant pattern. To generate this image the following code was excuted:

``` Haskell
--best read from bottom up
infiniSquare = publishFullFigure colouredFractal where --this line saves the shape to svg
    --colour the fractal
    --(14,14,14,14,14,14) is the grey fill
    --(0,0,255) is the blue outline
    colouredFractal = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare
    
    --recursiveSquare is the actual list of points for the fractal, it is achieved by making the square smaller each time and rotating it
    recursiveSquare = recursivePolygon newSquare [(scale 0.9 0.9),(translate 10 10),(rot 0.01)] 1000
    
    --newSquare is simply a larger base square to start the fractal
    --the |=> simply applies a list of transformations to a poly
    newSquare = [(scale 4 4), (translate 10 10)] |=> square
```

---

###Fibonacci Spiral:

My favourite kind of spiral, I liked the look of it flairing out as it gets bigger.

![FibonacciSpiral](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/da0fc6c2/Core/svg/Fibonacci_Demo.svg)

This spiral is also simple to make as it is just a square which rotates as it moves away from its start point.
Because its an SVG zooming in on it shows the detail of the spiral nicely. Its made using the following code below:

``` Haskell
fibonacci = publishFigure $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400
```
As you can see its a one liner, but it can be broken up into steps:
* `publishFigure` will simply convert the shape to SVG so we can see it.
* `centreFigure` finds the bounding box of the shape then translates the whole shape so its bouding box is relative to origin.
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

---

###Fractal Tree

A cliche fractal but very pretty non-the-less, once again the advantage of SVG makes zooming very satisfying:

![firstTree](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/73ad6285/Core/svg/Basic_Tree.svg)

This is less simple to make but haskell makes it relatively easy for us. I decided to not do this all on one line but it is definitely possible if you so
desire.

``` Haskell
firstTree = publishFigure finalTree where
    finalTree = centreFigure $ concat $ concat tree
    tree = recursiveFigure_adv base treeFunc 11
    base = [[[(scale 0.4 1.4)] |=> square]]
    treeFunc = (\fig -> (leaf1 fig)++(leaf2 fig))
    leaf1 fig = (map (\x -> [(translate 10 (-160)),(scale 0.75 0.75),(rot (-25))] |=> x) fig)
    leaf2 fig = (map (\x -> [(translate 0 (-140)),(scale 0.75 0.75),(rot 25)] |=> x) fig)
```

So its a little overwheleming at first, but once again i believe that seeing the type signature for recursiveFigure_adv helps a lot.

``` Haskell
recursiveFigure_adv :: [a] -> (a -> a) -> Int -> [[a]]
```

This function essentially has 3 parameters and returns a `[[a]]`, which is a list 
of list of a. The first parameter is the base shape of the recursive
shape `[a]` or as we know it as `[Figure]`. 
The second parameter is where the complexitity is `(a -> a)`. And the 3rd
parameter is the number of iterations to perform `Int`.

lets focus on the second parameter `(a -> a)` which seems redundant. Take any type and return any type.
But what this is actually doing; Is allowing me to pass a function to recursiveFigure_adv 
which can perform the transformations and rebuild the figure all in one parameter.
Hence explaining what `treeFunc` is doing. It performs a transformation on every polygon in base,
then appends this to another set of transformations. Which is also on every polygon in base.

---

###Tiling Fractal

Not sure if this is a well known fractal but i like the way it looks so i thought it deserved a place on the readme:

![tiling](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/a586d29e/Core/svg/Tiling_Demo.svg)

This is also less simple but not too much of a stretch to get your head around. It uses the same recursive
function as the tree just a slightly different transformation function.

``` Haskell
publishTiling =  publishFullFigure $ fullRNG 19 $ centreFigure $ reverse $ concat $ concat tiling
tiling =  recursiveFigure_adv [[base]] tile_func 6 where
    base = regularPolygon 200 6
    tile_func = (\fig -> (tile 0 fig)++(tile 60 fig)++(tile 120 fig)++(tile 180 fig)++(tile 240 fig)++(tile 300 fig))
    tile r = map (\x -> [(scale 0.5 0.5),(moveEuclidean 400 r)] |=> x)
```

`moveEuclidean` is a function allows for a transformation in a direction specfied in degrees
that moves the specfied number of pixels. This just uses simple trig to do this, its
found in `extraTransformations.hs`.

---

###Sierpinski Triangle

A classic fractal. Wikipedia article [here](https://en.wikipedia.org/wiki/Sierpinski_triangle)

![Triangle](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/a3ffb104/Core/svg/Sierpinski_2.svg)

This one is basically a tiling fractal so the code is really similar to the hexagon one above.

``` Haskell 
sierpinski =  publishFullFigure $ colourizeFig greyF blueL $ centreFigure $ transformFigure [(rot 180)] $ concat $ concat $ recursiveFigure_adv [[base]] tile_func 11 where
    base = regularPolygon 300 3
    tile_func = (\fig -> (tile 0 fig)++(tile 120 fig)++(tile 240 fig))
    tile r = map (\x -> [(scale 0.5 0.5),(moveEuclidean 300 r)] |=> x)
```

---

## Author

Code edited and Maintained by Alex Lewis