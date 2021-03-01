#include <stdio.h>
#include <math.h>
#include "funkcje.h"

#define LEVEL_MAX 10

/*
comment necessary to do the comments deletion task
Ala ma kota
Ola ma psa
*/

double recursive_calculation(double (*function)(double), double a, double fa, double c, double fc, double b, double fb, double Q, double tol, int level) {
	double c1, c2, fc1, fc2, Q1, Q2;
	c1 = (a + c) / 2;  fc1 = function(c1);
	Q1 = (c - a) / 6 * (fa + 4 * fc1 + fc);
	c2 = (b + c) / 2;  fc2 = function(c2);
	Q2 = (b - c) / 6 * (fc + 4 * fc2 + fb);
	if (fabs(Q1 + Q2 - Q) < tol) {
		return Q1 + Q2;
	}
	if (level > LEVEL_MAX)  return NAN;
	return recursive_calculation(function, a, fa, c1, fc1, c, fc, Q1, tol / 2, level + 1) + recursive_calculation(function, c, fc, c2, fc2, b, fb, Q2, tol / 2, level + 1);
}

int main(void) {
	double (*function)(double);
	double a = 0.0, b = 2.0, c;
	double fa, fb, fc, Q, tol = 1e-3;
	int level = 0;

	function = &function1;
	c = (a + b) / 2;
	fa = function(a);
	fb = function(b);
	fc = function(c);
	Q = (b - a) / 6 * (fa + 4 * fc + fb);
	printf("calka = %15.10f\n", recursive_calculation(function, a, fa, c, fc, b, fb, Q, tol, level));
	
	function = &function2;
	c = (a + b) / 2;
	fa = function(a);
	fb = function(b);
	fc = function(c);
	Q = (b - a) / 6 * (fa + 4 * fc + fb);
	printf("calka = %15.10f\n", recursive_calculation(function, a, fa, c, fc, b, fb, Q, tol, level));

	function = &function3;
	c = (a + b) / 2;
	fa = function(a);
	fb = function(b);
	fc = function(c);
	Q = (b - a) / 6 * (fa + 4 * fc + fb);
	printf("calka = %15.10f\n", recursive_calculation(function, a, fa, c, fc, b, fb, Q, tol, level));

	return 0;
}
