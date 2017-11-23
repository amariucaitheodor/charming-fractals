# Charming fractals
TL;DR: This short program which I've written here in Haskell renders an image based on Newton's fractal. I have heavily relied on modifying various parameters to create impressive results (see `Fractals\Showcase`). Images located in `Fractals\Studies` bear their corresponding parameters (used to render them) as their names. This makes working with lots of fractals INSANELY easier.
To install dependencies (Graphics.GD library):
cabal install gd
sudo apt-get install libgd2-xpm-dev

----------------------------
How to run:
 - Compile Main.hs
 - type "main" and run it
 - my favourite fractal should be created in the directory "Fractals" and named after its parameters.
----------------------------

Naturally, real numbers don't bear much variation when it comes to converging to either one of an equation's roots. They just rush to the closest root. Here is where complex numbers come into play (we import the Data.Complex library to represent those). Each pixel's coordinates in an image represent a complex number's real and imaginary parts. The real part is on the X-axis and imaginary part is on the Y-axis (see first link in references for more info).

----------------------------
Explanation of functions:
function x: Newton's method will be applied to this function.
function' x: the function's derivative is also required.
reals, imags: the function's approximated solutions.

iSize: the size of the generated picture. Choose this one carefully (it takes a while for images of over 1 million pixels to render).

edge: Our complex plane will be a square containing the origin (point of 0,0) right in the middle. Choose the size of the edge in real numbers (the smaller the edge, the bigger the zoom).

fractalScale: sets the complex plane in which we operate and thus the zoom of the fractal. (also known as its 'scale')

delta: the difference between two approximated roots (has to be low enough for us to declare a successful find)

maxIter: after this many iterations we conclude the point does not converge to sought root.

closeRoot (used in function 'colorize'): real and imaginary parts of reached number differ by this much from a certain root's own real and imaginary parts, therefore we conclude this should be the corresponding root and we assign its colour to the reached number

shadeTresh: the five thresholds needed to determine the shade of one pixel (I have manually entered 5 shades for each color in the module 'Color.hs')

----------------------------

----------------------------
Pixel shader information:
The shader which I've written links pixel shades with the corresponding number of iterations. I mainly decided to ignore the trivial method of setting the shade of a pixel to its number of iterations modulo the number of available shades (method which will cycle through colors). Instead I found another viable method using iteration-dependent thresholds.
My method is quite tedious to set up because of the fact that, usually, specific shade thresholds need to be found for every single combination of parameters in order for the image to properly and proportionately display all of the shades. In conclusion, parameters and shade thresholds need to be tweaked manually. (although the third entry in my list of references contains some interesting information on how to further level the boundaries between different shades, I've decided to stop here).

----------------------------

----------------------------
Nova fractals:
Although I've tried creating some nova fractals as seen in `Fractals\Studies\novaFractals`, my results were not very pretty. I believe some heavy post-processing is needed for this particular job.

----------------------------

----------------------------
References:
-- Very rewarding read. Even if unrelated to Newton's Method, acts as a general introduction to fractals:
https://mathcs.clarku.edu/~djoyce/julia/julia.html

-- Essential math theory (previous contact with derivatives helps a great deal):
http://tutorial.math.lamar.edu/Classes/CalcI/NewtonsMethod.aspx

-- Everything you need to know
https://www.chiark.greenend.org.uk/~sgtatham/newton/

-- Some inspiration
https://en.wikipedia.org/wiki/Newton_fractal

-- On nova fractals:
http://www.hpdz.net/TechInfo/Convergent.htm#Nova
http://www.hpdz.net/StillImages/Nova.htm
http://usefuljs.net/fractals/docs/newtonian_fractals.html

----------------------------

Theodor Amariucai, FP Programming Competition 2017
