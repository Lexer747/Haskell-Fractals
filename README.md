# Haskell Shape & Fractals
Currently a simple program which creates pretty shapes in svg format which can be rendered by 
most browsers.

Core code for generating the svg was found [here](http://stackoverflow.com/questions/2711002/image-drawing-library-for-haskell)
and inspired me in its simplicty.

## Sample images:

Simple bounding box demonstration:

![BoundingBox](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/ae0c3551/svg/BoundingBox_Demo.svg)

The blue rectangle is created using affine transformations then the grey rectangle is produce by finding the bouding box of the shape.

---

First Fractal:

![Squares](https://cdn.rawgit.com/Lexer747/Haskell-Fractals/8650b7e6/Core/svg/InfiniteSquares_Demo.svg)

This fractal is created by scaling and rotating a square 1000 times. Its a simple but elegant pattern. To generate this image the following code was excuted:

''' haskell
--first make a big square as the base polygon
let newSquare = transformPolygon [(scale 4 4), (translate 10 10)] square

--make the fractal by applying a transformation 1000 times
let recursiveSquare = recursiveFigure newSquare [(scale 0.9 0.9), (translate 10 10), (rot 0.01)] 1000

--colour the shape 
--(14,14,14,14,14,14) is the grey fill
--(0,0,255) is the blue border
let colouredFractal = colourizeFig (14,14,14,14,14,14) (0,0,255) recursiveSquare

--save the shape to an svg
--automatically saved to svg/Output.svg
publishFullFigure colouredFractal
'''

---



## Author

Code edited and Maintained by Alex Lewis