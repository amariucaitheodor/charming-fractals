module Newton where
import Data.Complex
import Graphics.GD
import Colors (colors, blues, teals, black, white)
import Data.List (findIndex)

---------------------------------------PARAMETERS---------------------------------------
function x = x^8+15*x^4-16
function' x = 8*x^7+60*x^3

reals :: [Double]
reals = [-1, 1, 0, 0, 1.41421356, -1.41421356, -1.41421356, 1.41421356]

imags :: [Double]
imags = [0, 0, 1, -1, 1.41421356, -1.41421356, 1.41421356, -1.41421356]

iSize :: Size
iSize = (300,300) --Should take less than 15 seconds. On the other hand, 1200x1200 will take a while for this default image.
edge :: Double
edge = 2
delta :: Double
delta = 1e-6
maxIter :: Int
maxIter = 250
closeRoot :: Double
closeRoot = 1e-2
-----------------------------------------------------------------------------------------
fractalSlice :: Rectangle
fractalSlice = --((-edge/2,edge/2), (edge/2,-edge/2)) --BASIC
                ((0.5, 1.5), (1.5, 0.5))  --CUSTOM FOR 'TWISTER'
                --((-1.6, 0.6), (0.8, -0.6)) --CUSTOM FOR NOVA FRACTAL

roots = zipWith (:+) reals imags
coloredRoots :: [(Complex Double, [Color])]
coloredRoots = zip roots (cycle colors)
--(only for 9+ roots) WARNING: we cycle the colors because there are only so many colors available

shadeThresh :: [Int]
--FOR THRESHOLDS AS PERCENTAGES OF MAXITER (not very impressive results):
--shadeThresh = map round (zipWith (*) [1..5] (replicate 5 (fromIntegral maxIter/5)))
--FOR CUSTOM THRESHOLDS
shadeThresh = [4,7,10,13,16] -- naturally, maxIter has to be higher than last member of shadeThresh for all shades to be used

newton :: Complex Double -- complex number
          -> Int --function inherits no of previous interations
          -> (Int, Complex Double) --returns necessary number of iterations in order to converge and the root it converges to (approximated)
newton c it
  | it > maxIter = (0, c) -- c does not converge to a root
  | delta < abs (magnitude c - magnitude new) = newton new (it+1) -- delta is not small enough for us to conclude we're close enough to a root, we keep applying Newton's method on the newly obtained approximation
  | otherwise = (it, c) -- delta is small enough for us to conclude we're close enough to a root
  where
    new = c - function c / function' c

novaNewton :: Complex Double -- initial value of guess (preferably a whole number)
          -> Complex Double -- Value of c (free parameter, just like in Mandelbrot sets. We set this to the pixel's value)
          -> Int
          -> (Int, Complex Double)
novaNewton c pixVal it
  | it > maxIter = (0, c)
  | delta < abs (magnitude c - magnitude new) = novaNewton new pixVal (it+1)
  | otherwise = (it, c)
  where
    new = c - function c / function' c + pixVal

-- randomColor is based on the easiest shading method. It essentially groups values with the same number of iterations under the same shade. As the name already suggests, its output is extremely unpredictable under the slightest changes (changes in terms of the formula applied to `it`). The main downside obviously is that shades are cycled (due to the use of `mod`).
randomColor :: Int -> Color
randomColor it = rgb (it `mod` 256) ((it^2) `mod` 256) ((it^3) `mod` 256)

correctShade :: Int -- nr of iterations
                -> [Color] -- shades
                -> Color -- correct shades
correctShade it shades = --last shades --SHADER OFF
                         shades!!rightShadeNo --SHADER ON
                          --Note: the method using rightShadeNo groups values located between two thresholds, not necessarily of the same number of iterations!
                          --shades!!(it`mod`5) groups numbers with the same number of iterations under the same shade. Just as in randomColor, shades are cycled.
 where
  rightShadeNo = case findIndex (>=it) shadeThresh of
                  Nothing -> 4 --this case is never reached for shadeThresh set as percentages of MaxIter. In case of a custom shadeThresh, highest shader index (4) is chosen if the number of iterations (`it`) goes over the last member of the custom shadeTresh.
                  (Just x)-> x

colorize :: (Int, Complex Double) -- (number of iterations, corresponding complex number)
            -> Color -- assigns a color based on root reached
colorize (n, c)
  | n==0 = white --For nova fractals: last blues
  -- What we get here:
  -- divergent numbers (including middlepoints)
  -- roots (they reach the threshold after just 1 iteration obviously)
  -- !! if delta is too high some values other than the root may actually reach the threshold after just 1 iteration
  | otherwise = f [ correctShade n shades | (root, shades)<-coloredRoots, closeRoot > abs (realPart root - realPart c), closeRoot > abs (imagPart root - imagPart c)] --FOR RANDOM COLORS: randomColor n
  where
    f [] = black --For nova fractals: last teals
    -- if delta is too high, some values won't get close enough to their root (according to our standard -"closeRoot") and thus their corresponding root won't be identified in the zipped list (I've set them to appear in black as a consequence - also helps with debugging). They don't diverge though, that's why they don't appear in white. Also they make for some pretty great pictures resembling a cobweb (see `Fractals\Studies\highDelta' for reference).
    f xs = head xs --we found the corresponding root

-- Assigns color to a pixel based on its coordinate.
colorNewton :: Coordinate -> Color
colorNewton (x,y) = colorize (newton (x :+ y) 0)

-- Assigns color to a pixel based on its coordinate (nova fractals).
colorNovaNewton :: Coordinate -> Color
colorNovaNewton (x,y) = colorize (novaNewton (1 :+ 0) (x :+ y) 0)

main :: IO () --brain of our program
main = render iSize fractalSlice (concat ["edge: ", show edge, ", delta: ", show delta, ", maxIter: ", show maxIter, ", closeRoot: ", show closeRoot, ", fRoots: ", concatMap (\x -> show x ++ ", ") (take 5 roots), ".png"]) colorNewton --FOR NOVA FRACTAL: colorNovaNewton

--------------------------------------- RENDERING---------------------------------------
-- Coordinate in a complex plane.
type Coordinate = (Double, Double)

-- Boundary coordinates of a part of a complex plane which we want to draw.
type Rectangle = (Coordinate, Coordinate)

pixels :: Size -- This is a type in Graphics.GD which determines the size of a picture (Int, Int)
          -> [Point] --returns a list of all the pixels in an image
pixels (sizex, sizey) = [(x,y) | x <- [0..sizex-1], y <- [0..sizey-1]]

toCoordinate :: Point --a particular point
                -> Size --size of a picture
                -> Rectangle --boundary coordinates
                -> Coordinate --coordinates corresponding to the pixel
toCoordinate (x, y) (sizex, sizey) ((a, b), (c, d)) =
  (a + (c-a)*tX , b + (d-b)*tY )
  where tX = fromIntegral x / fromIntegral sizex
        tY = fromIntegral y / fromIntegral sizey

render :: Size -- picture size
        -> Rectangle -- boundary coordinates of a plotted part of a complex plane
        -> String -- name of the creation
        -> (Coordinate -> Color) -- assigns a color to each pixel
        -> IO () -- final command waiting for `main` to render our masterpiece
render size boundaries name f =
  do
  picture <- newImage size
  mapM_ (g picture) $ pixels size
  savePngFile ("Fractals/" ++ name) picture
  where
  g picture p = setPixel p (f(toCoordinate p size boundaries)) picture
-----------------------------------------------------------------------------------------
