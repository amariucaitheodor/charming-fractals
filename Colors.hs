module Colors where
import Graphics.GD

black = rgb 0 0 0
white = rgb 255 255 255

orange = rgb 255 128 0
purple = rgb 127 0 255
pink = rgb 255 0 255
yellow = rgb 255 255 0
red = rgb 255 0 0
green = rgb 0 255 0
teal = rgb 0 255 255
blue = rgb 0 128 255

colors :: [[Color]]
colors = [reds, blues, yellows, greens, oranges, purples, pinks, teals]

reds :: [Color]
reds  = [rgb 255 204 204, rgb 255 153 153, rgb 255 102 102, rgb 255 51 51, red]

oranges :: [Color]
oranges = [rgb 255 229 204, rgb 255 204 153, rgb 255 178 102, rgb 255 153 51, orange]

yellows :: [Color]
yellows  = [rgb 255 255 204, rgb 255 255 153, rgb 255 255 102, rgb 255 255 51, yellow]

greens :: [Color]
greens  = [rgb 204 255 204, rgb 153 255 153, rgb 102 255 102, rgb 51 255 51, green]

purples :: [Color]
purples  = [rgb 229 204 255, rgb 204 153 255, rgb 178 102 255, rgb 153 51 255, purple]

pinks :: [Color]
pinks = [rgb 255 204 255, rgb 255 153 255, rgb 255 102 255, rgb 255 51 255, pink]

teals :: [Color]
teals  = [rgb 204 255 255, rgb 153 255 255, rgb 102 255 255, rgb 51 255 255, teal]

blues :: [Color]
blues  = [rgb 204 229 255, rgb 153 204 255, rgb 102 178 255, rgb 51 153 255, blue]
