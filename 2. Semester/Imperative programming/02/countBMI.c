// Count BMI. Obligatory input: weight in kgs, height in cms 

#include <stdio.h>

double convert(int height) {
    double result;
    result = (double) height / 100;
    return result;
}

double countBmi(int weight, double height) {
    double result;
    result = (double) weight / (height * height);
    return result;
}

int main() {
    int height, weight;
    scanf("%d %d", &height, &weight);
    printf("%lf\n", countBmi(weight, convert(height)));

    return 0;   
}