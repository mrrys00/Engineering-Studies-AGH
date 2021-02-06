#include <stdio.h>
#include <math.h>

#define LEVEL_MAX 10

double funkcja(double x) {
//  return x*x*x*x;
//	return sin(x);
	return 1.0/((x-0.5)*(x-0.5)+0.01);
}

double oblicz_rek(double a, double fa, double c, double fc,double b, double fb, double Q, double tol, int poziom){
	double c1,c2,fc1,fc2,Q1,Q2;
	c1 = (a+c)/2;  fc1 = funkcja(c1);  // funkcja w tym punkcie nigdy nie by�a i nie b�dzie obliczana 
	Q1 = (c-a)/6 * (fa +4*fc1 + fc);   // ca�ka z lewej po��wki
	c2 = (b+c)/2;  fc2 = funkcja(c2);  // funkcja w tym punkcie nigdy nie by�a i nie b�dzie obliczana
	Q2 = (b-c)/6 * (fc +4*fc2 + fb);   // ca�ka z prawej po��wki
	if(fabs(Q1+Q2-Q) < tol) {
//		printf("przedzial = %10.7f,  poziom = %2d\n",b-a, poziom);
	    return Q1+Q2;                  // zwracana suma jest dok�adniejszym przybli�eniem ca�ki ni� Q 
	}
	if(poziom > LEVEL_MAX)  return NAN;   // ka�da p�niejsza operacja arytmetyczna z NaN da w wyniku warto�� NAN - a� do wyj�cia do main
	return oblicz_rek(a,fa,c1,fc1,c,fc,Q1, tol/2, poziom+1) + oblicz_rek(c,fc,c2,fc2,b,fb,Q2,tol/2,poziom+1);
                      // zast�pienie sumy poziom+1 inkrementacj� by�oby b��dem! Dlaczego? 
}

int main(void) {
	double a=0., b=2., c;
	double fa,fb,fc, Q, tol=1e-3;
	int poziom = 0;
	c = (a+b)/2;
	fa = funkcja(a);
	fb = funkcja(b);
	fc = funkcja(c);
	Q = (b-a)/6 * (fa +4*fc + fb);	
	printf("calka = %15.10f\n", oblicz_rek(a, fa, c, fc, b, fb, Q, tol, poziom));
    return 0;
}
