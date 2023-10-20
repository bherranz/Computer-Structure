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

void SinMatrix(float **A, float **B, int N, int M)
{
    int i = 0;
    while (i < N)
    {
        int j = 0;
        while (j < M)
        {
            B[i][j] = ft_sin(A[i][j]);
            j++;
        }
        i++;
    }
}
