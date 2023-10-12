def exp1(n: int):
    if n%2 == 0:
        return 1
    else:
        return -1

def exp2(x: int, n: int):
    a = 2
    b = 1
    counter = 1
    copy = x
    up_bound = a*n + b
    while counter < up_bound:
        x = x*copy
        counter += 1
    return x

def factorial(n: int):
    # Non terminal function will store a, b, c in registers of type s
    # And we need to store the variables in the stack(first push and then pop)
    a = 2
    b = 1
    counter = 1
    fact1 = a*n + b
    result = 1
    while counter <= fact1:
        result = result * counter
        counter += 1
    return result # Result is stored in a0 register

def sin(x: int, n: int):
    t0 = exp1(n)
    t1 = exp2(x, n)
    t2 = factorial(n)
    result = (t0*t1)/t2
    return result

counter = 0
n = 
x = 2
sum = 0
while counter <= n:
    a = sin(x, counter)
    sum = sum + a
    counter += 1
print(sum)




