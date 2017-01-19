# Haskell Shape & Fractals
Currently a simple program which creates pretty shapes in svg format which can be rendered by 
most browsers.

Core code for generating the svg was found [here](http://stackoverflow.com/questions/2711002/image-drawing-library-for-haskell)
and inspired me in its simplicty.

## Sample images:

###Bounding Box:

![BoundingBox](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/ae0c3551/svg/BoundingBox_Demo.svg)

The blue rectangle is created using affine transformations then the grey rectangle is produce by finding the bouding box of the shape.

---

###First Fractal:

![Squares](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/8650b7e6/Core/svg/InfiniteSquares_Demo.svg)

This fractal is created by scaling and rotating a square 1000 times. Its a simple but elegant pattern. To generate this image the following code was excuted:

``` haskell
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

```haskell
fibonacci = publishFigure $ centreFigure $ recursivePolygon ([(scale 0.01 0.01)] |=> square) [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))] 400
```
As you can see its a one liner, but it can be broken up into steps:
* `publishFigure` will simply convert the shape to SVG so we can see it.
* `centreFigure` finds the bounding box of the shape then translates the whole shape so its bouding box is relative to origin.
* `recursivePolygon` takes the base square and recursively applies the list of transformations to it forming the spiral.

Explaining the `recursivePolygon` function and why it looks so crazy. Seeing the type of `recursivePolygon` makes understanding it easier:

``` haskell
recursivePolygon :: Polygon -> [Transformation] -> Int -> Figure
```

So it takes a `Polygon` , a list of `Transformation` and an `Int`. Then it spits out a `Figure` , 
hence in the code for this spiral we can analyze the parameters to be as such:

``` haskell
    Polygon             = ([scale 0.01 0.01] |=> square)
    [Transformation]    = [(rot 1),(scale 1.01 1.01), (translate 0 (-0.05))]
    Int                 = 400
```

This should make reading the function easier (hopefully).

---


## Author

Code edited and Maintained by Alex Lewis