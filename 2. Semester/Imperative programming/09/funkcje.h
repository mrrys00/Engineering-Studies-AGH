#include <math.h>

double function1(double x) {
    return 1.0 / ((x - 0.5) * (x - 0.5) + 0.01);
}

double function2(double x) {
    return sin(x);
}

double function3(double x) {
    return x*x*x*x;
}