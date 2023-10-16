"""
Created by belén in oct 2023
Universidad Carlos III de Madrid
"""


def exponential_r(base: float, exp: int) -> float:
    if exp == 0:
        return 1
    return base * exponential_r(base, exp - 1)


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


def factorial_r(num: int) -> int:
    if num == 0 or num == 1:
        return 1
    return num * factorial(num - 1)


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


# main
print(exponential(3, 3))
print(factorial(5))
print(factorial_r(5))
print(sin(1))
