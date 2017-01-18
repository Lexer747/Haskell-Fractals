# Haskell Shape & Fractals
Currently a simple program which creates pretty shapes in svg format which can be rendered by 
most browsers.

Core code for generating the svg was found [here](http://stackoverflow.com/questions/2711002/image-drawing-library-for-haskell)
and inspired me in its simplicty.

## Sample images:

#Bounding Box:

![BoundingBox](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/ae0c3551/svg/BoundingBox_Demo.svg)

The blue rectangle is created using affine transformations then the grey rectangle is produce by finding the bouding box of the shape.

---

#First Fractal:

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
    newSquare = [(scale 4 4), (translate 10 10)] |=> square
```

---

#Tree Fractal:

![todo]

---


## Author

Code edited and Maintained by Alex Lewis