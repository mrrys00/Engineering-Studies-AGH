# ElasticDeformation

Finite elements method for elastic deformation problem described [here](zadanie_obliczeniowe.pdf). <br>
Mathematical FEM explaination is [here](MES.pdf).

### Requirements
* Go 1.14 
* make
* gnuplot

### Build and run:
Use ```make draw_graph%``` where `%` is N parameter and N is natural number that belongs to set [2, 100]

### Results:
Result chart will create automatically [here](elasticDeformation.png) and text verision will create [here](result.txt)

### Note:
There is one mistake during calculating the system of linear equations, however the project scored 100%.