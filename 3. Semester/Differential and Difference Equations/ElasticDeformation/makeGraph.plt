set terminal pngcairo enhanced font "arial,10" fontscale 1.0 size 1024, 768
set key left top
set title "Elastic deformation" font "arial, 40"

set grid
set output './elasticDeformation.png'
plot "./result.txt" using 1:2 title "" lt rgb "blue" with line