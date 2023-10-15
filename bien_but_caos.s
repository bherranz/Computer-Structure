.data
	one: .float 1.0
    cero: .float 0.0
    rest: .float 0.001
    minus_one: .float -1.0
    two: .float 2.0
	msg: .string "Introduce x to calculate sin(x): "
.text
main:   #print msg
		la a0, msg
		li a7, 4
        ecall
		# read x of sin(x), a0 = x
        li a7, 6
        ecall
        jal ra sin

sin:
    fmv.s fa2, fa0    # Inicializa current = x (current = fa2)
    fmv.s fa7, fa0
    li a4, 0 # n = 0
    # prev (fa3) = 0
    fsub.s fa1, fa3, fa2 # sub_pc = prev - current
    fabs.s fa1, fa1 # |sub_pc|
		
sin_loop:# Comprueba si sub_pc >= 0.001
   		la t6, rest
    	flw ft7, 0(t6)
    	flt.s a5, fa1, ft7 # Compara sub_pc con 0.001
    	bnez a5, end_s  # Si sub_pc >= 0.001, continúa el bucle
		# current = fa1, expo(x, 2*n + 1) = ft3, expo(-1, n) = ft4, factorial(2*n + 1) = a0
		addi a4, a4, 1 #n++
        # expo(x: base = fa0, 2*n + 1: ex, a3)  = ft3
		li t5, 2
        mul a3, t5, a4
        addi a3, a3, 1
        fmv.s fa0, fa7
        jal ra expo
        fmv.s ft3, fa0
        #expo(-1: base, fa0, n: ex, a3) = ft4
        la t2, minus_one
		flw ft2, 0(t2)
        fmv.s fa0, ft2 # -1
        mv a3, a4
        jal ra expo
        fmv.s ft4, fa0
        # factorial (2*n + 1) = a0
        li t5, two
        flw ft9, 0(t5)
        fcvt.s.w ft10, a4
        fmul.s fa0, ft9, ft10
        la t1, one # load address one
        flw ft8, 0(t1)
        fadd.s fa0, fa0, ft8
        jal ra factorial
		fmv.s ft0, fa0 # ft0 for factorial
      	fmul.s ft1, ft3, ft4 # expo1 * expo2
      	fdiv.s ft1, ft1, ft0 # expo1 * expo2 / factorial
      	fmv.s fa3, fa2 # prev = current
      	fadd.s fa2, ft1, fa2 # current = current + operation
      	fsub.s fa1, fa3, fa2 # sub_pc = prev - current
      	fabs.s fa1, fa1 # |sub_pc|
    	j sin_loop
		

expo:	# ex = a3, fa7 = base
		beq a3, zero, end1 # if ex == 0 go to end1
		fmv.s fa1, fa0 # current = base
        li t1, 1
        
        while:	beq a3, t1, end2 # while (ex > 1)
        		fmul.s fa1, fa1, fa0 # current = current * base
                addi a3, a3, -1 # ex--
        		j while
                
		end1:   la t1, one # load address one
        		flw ft1, 0(t1) # load register t1
        		fmv.s fa0, ft1 # return 1.0
        		j end_e
        end2: fmv.s fa0, fa1 # return current(fa0)
        end_e:  
				jr ra

factorial:  
			la t1, one # load address one
        	flw ft5, 0(t1) # load register ft5 = 1 for count
        	flw ft6, 0(t1) # load register ft6 = 1 for result
            flw ft8, 0(t1)
			loop:   flt.s t5, fa0, ft5 # fa0 for num
            		bnez t5, end_f
					fmul.s ft6, ft6, ft5 # result = result * count
					fadd.s ft5, ft5, ft8 # count++
					j loop
      
			end_f:  fmv.s fa0, ft6 # result (a0)
					jr ra

end_s:  fmv.s fa0, fa2 # current to fa0
		# print sin(x)
        li a7, 2
        ecall
		# exit
        li a7, 10
        ecall