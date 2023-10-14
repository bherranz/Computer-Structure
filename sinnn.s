.data
	one: .float 1.0
    cero: .float 0.0
    rest: .float 0.001
    minus_one: .float -1.0
	msg: .string "Introduce x to calculate sin(x): "
.text
main:   # read x of sin(x), a0 = x
        li a7, 6
        ecall
        jal ra sin
        # print sin(x)
        li a7, 2
        ecall
        # exit
        li a7, 10
        ecall

sin: fmv.s fa1, fa0  # Copia el valor de x a fa1 (fa0 se usará para el resultado)
    fmv.s fa3, ft0 # Inicializa prev = 0.0 (prev = fa3)
    fmv.s ft1, fa1    # Inicializa current = x (current = fa10)
        
		
sin_loop:
		# current = ft1, expo(x, 2*n + 1) = ft3, expo(-1, n) = ft4, factorial(2*n + 1) = a0
		addi t3, t3, 1 #n++
        # expo(x: base, fa0, 2*n + 1: ex, a3)
		li t5, 2
        mul a3, t5, t3
        addi a3, a3, 1
        jal ra expo
        fmv.s ft3, fa0
        #expo(-1: base, fa0, n: ex, a3)
        la t2, minus_one
		flw ft2, 0(t2)
        fmv.s fa0, ft2 # -1
        mv a3, t3
        jal ra expo
        fmv.s ft4, fa0
        # factorial (2*n + 1)
        li t5, 2
        mul a0, t5, t3
        addi a0, a0, 1
        jal ra factorial
      # expo1 * expo2
      fmul.s ft1, ft3, ft4
      fcvt.s.w ft0, a0
      fdiv.s ft1, ft1, ft0
      fadd.s ft1, ft1, fa3
      fsub.s fa1, fa3, ft1
      fabs.s fa1, fa1
    
    	# Comprueba si sub_pc >= 0.001
   		la t6, rest
    	flw ft7, 0(t6)
    	flt.s a5, fa1, ft7 # Compara sub_pc con 0.001
    	beqz a5, sin_loop   # Si sub_pc >= 0.001, continúa el bucle
		fmv.s fa0, ft1
    	jr ra
		

expo:	# ex = a3, fa0 = base
		beq a3, zero, end1 # if ex == 0 go to end1
		fmv.s ft0, fa0 # current = base
        li t1, 1
        
        while:	beq a3, t1, end2 # while (ex > 1)
        		fmul.s ft0, ft0, fa0 # current = current * base
                addi a3, a3, -1 # ex--
        		j while
                
		end1:   la t1, one # load address one
        		flw ft1, 0(t1) # load register t1
        		fmv.s fa0, ft1 # return 1.0
        		j end_e
        end2: fmv.s fa0, ft0 # return current(fa0)
        end_e: jr ra

factorial:  
			li t0, 1 # s0 for count
			li t1, 1 # s1 for result
			loop:   bgt t0, a0, end_f # a0 for num
					mul t1, t1, t0 # result = result * count
					addi t0, t0, 1 # count++
					j loop
      
			end_f:  mv a0, t1 # result (a0)
					jr ra
		