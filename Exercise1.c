#include <math.h>

float   exponential(float base, int exp)
{
    float   current;
    if (exp == 0)
        return (1);
    current = base;
    while (exp > 1)
    {
        current = current * base;
        exp--;
    }
    return (current);
}

float   factorial(int num)
{
    float   count = 1;
    float   result = 1;
    while (count <= num)
    {
        result = result * count;
        count++;
    }
    return (result);
}
// I use "ft_" before my functions because the library math.h already
// has these functions named sin(x) and cos(x)
float   ft_sin(float x)
{
    float   prev = 0;
    int     n = 0;
    float   current = x;
    while (fabs(prev - current) > 0.001)
    {
        n++;
        prev = current;
        current = current + exponential(-1, n) * exponential(x, 2*n + 1) /
                    factorial(2*n + 1);
    }
    return (current);
}

float   ft_cos(float x)
{
    float   prev = 0;
    int     n = 0;
    float   current = 1;
    while (fabs(prev - current) > 0.001)
    {
        n++;
        prev = current;
        current = current + exponential(-1, n) * exponential(x, 2*n) /
                    factorial(2*n);
    }
    return (current);   
}

float   ft_tg(float x)
{
    if (fabs(ft_cos(x)) < 0.001)
        return (1.0 / 0.0); // Positive infinity
    return (ft_sin(x) / ft_cos(x));
}

float   E(void)
{
    float   prev = 0;
    int     n = 0;
    float   current = 1;
    while (fabs(prev - current) > 0.001)
    {
        prev = current;
        n++;
        current = current + 1 / factorial(n);
    }
    return (current);
}
