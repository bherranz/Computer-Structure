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


def cos(x: float) -> float:
    prev = 0
    n = 0
    current = 1
    while abs(prev - current) > 0.001:
        n += 1
        prev = current
        current += exponential(-1, n) * exponential(x, 2 * n) / factorial(2*n)
    return current


def tg(x: float) -> float:
    return sin(x) / cos(x)


def E() -> float:
    prev = 0
    n = 0
    current = 1
    while abs(prev - current) >= 0.001:
        prev = current
        n += 1
        current += 1 / factorial(n)
    return current
