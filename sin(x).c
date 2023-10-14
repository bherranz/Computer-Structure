#include <math.h>
#include <stdio.h>

float   expo(float base, int ex)
{
    float   current;

    if (ex == 0)
        return (1);
    current = base;
    while (ex > 1)
    {
        current = current * base;
        ex--;
    }
    return (current);
}

int factorial(int num)
{
    int count = 1;
    int result = 1;

    while (count <= num)
    {
        result = result * count;
        count++;
    }
    return (result);
}

float   sin_b(float x)
{
    float prev = 0;
    int n = 0;
    float current;
    float sub_pc;

    current = x;
    sub_pc = fabs(prev - current);
    while (sub_pc >= 0.001)
    {
        n++;
        prev = current;
        current = current + expo(-1, n) * expo(x, 2 * n + 1) / factorial(2 * n + 1);
        sub_pc = fabs(prev - current);
    }
    return current;
}

int main(void)
{
    printf("%f", sin(0.0001));
    return (0);
}
