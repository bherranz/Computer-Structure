.data
    
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
    fmv.s fs0, fa0    # Inicializa current = x (current = fs0)
    fmv.s fs1, fa0
    li s0, 0 # n = 0
    # prev (fa3) = 0
    fsub.s fa1, fa3, fs0 # sub_pc = prev - current
    fabs.s fa1, fa1 # |sub_pc|
		
sin_loop:
		# Comprueba si sub_pc >= 0.001
		li s1, 0x3D7A3D70 # We insert the 0.001 rest value
    	fmv.w.x fs2, s1
    	flt.s s2, fa1, fs2 # Compara sub_pc con 0.001
    	bnez s2, end_s  # Si sub_pc >= 0.001, continúa el bucle
        
		# current = fa1, expo(x, 2*n + 1) = ft3, expo(-1, n) = ft4, factorial(2*n + 1) = a0
        
        addi s0, s0, 1 #n++
        # expo(x: base = fa0, 2*n + 1: ex, a3)  = ft3
		li s3, 2
        mul s3, s0, s3 # 2*n
        addi a1, s3, 1 # 2*n + 1
        fmv.s fa0, fs1
        jal ra expo
        fmv.s fs3, fa0
        
        #expo(-1: base, fa0, n: ex, a3) = ft4
        li s4, 0xBF800000
		fmv.w.x fs4, s4
        fmv.s fa0, fs4 # -1
        mv a1, s0
        jal ra expo
        fmv.s fs4, fa0
        
        # factorial (2*n + 1) = a0
        li t1, 0x40000000
        fmv.w.x fs5, t1 # 2 in floating point
        fcvt.s.w fs6, s0
        fmul.s fa0, fs5, fs6 # 2*n
        li t1, 0x3F800000 
        fmv.w.x fs7, t1	 # load 1 in floating point
        fadd.s fa0, fa0, fs7 # 2*n + 1
        jal ra factorial
		fmv.s fs8, fa0 # ft0 for factorial
        
        
      	fmul.s ft1, fs3, fs4 # expo1 * expo2
      	fdiv.s ft1, ft1, fs8 # expo1 * expo2 / factorial
      	fmv.s fa3, fs0 # prev = current
      	fadd.s fs0, ft1, fs0 # current = current + operation
      	fsub.s fa1, fa3, fs0 # sub_pc = prev - current
      	fabs.s fa1, fa1 # |sub_pc|
    	j sin_loop


		

expo:	# ex = a1, fa0 = base
		beq a1, zero, end1 # if ex == 0 go to end1
		fmv.s fa1, fa0 # current = base
        li t1, 1
        
        while:	beq a1, t1, end2 # while (ex > 1)
        		fmul.s fa1, fa1, fa0 # current = current * base
                addi a1, a1, -1 # ex--
        		j while
                
		end1:   li t1, 0x3F800000 
        		fmv.w.x ft1, t1 # load 1 in floating point
        		fmv.s fa0, ft1 # return 1.0
        		j end_e
        end2: fmv.s fa0, fa1 # return current(fa0)
        end_e: jr ra

factorial:  
			li t1, 0x3F800000 # load address one
        	fmv.w.x ft5, t1 # load register ft5 = 1 for count
        	fmv.w.x ft6, t1 # load register ft6 = 1 for result
            fmv.w.x ft8, t1
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
