"""
Created by Belén Herranz and Izan Sánchez in oct 2023
Universidad Carlos III de Madrid
"""


def exponential(base: float, exp: int) -> float:
    if exp == 0:
        return 1
    current = base
    while exp > 1:
        current = current * base
        exp -= 1
    return current


def factorial(num: int) -> int:
    count = 1
    result = 1
    while count <= num:
        result = result * count
        count += 1
    return result


def sin(x: float) -> float:
    prev = 0
    n = 0
    current = x
    while abs(prev - current) > 0.001:
        n += 1
        prev = current
        current += exponential(-1, n) * exponential(x, 2 * n + 1) / \
            factorial(2 * n + 1)
    return current


def SinMatrix(A: list[list[float]], B: list[list[float]], N: int, M: int):
    i = 0
    while i < N:
        j = 0
        while j < M:
            B[i][j] = sin(A[i][j])
            j += 1
        i += 1
      
