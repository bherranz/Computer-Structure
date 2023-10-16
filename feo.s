.data
    
	msg: .string "Introduce x to calculate sin(x): 
    "
    s: .string "sin(x) = "
	space: .string "
    "
    e: .string "e = "
    


.text
main:   #print msg
		la a0, msg
		li a7, 4
        ecall
		# read x of sin(x), a0 = x
        li a7, 6
        ecall
        
        li a7, 4
        la a0, s
        ecall
        jal ra sin


sin:
    fmv.s fs0, fa0   # Inicializa current = x (current = fs0)
    fmv.s fs1, fa0	 # Store x value
    li s0, 0 # n = 0
    # prev (fa3) = 0
    fsub.s fa1, fa3, fs0 # sub_pc = prev - current
    fabs.s fa1, fa1 # |sub_pc|
		
    sin_loop:
            # Comprueba si sub_pc >= 0.001
            li s1, 0x3A83126F # We insert the 0.001 rest value
            fmv.w.x fs2, s1
            flt.s s2, fa1, fs2 # Compara sub_pc con 0.001
            bnez s2, end_s1  # Si sub_pc >= 0.001, continúa el bucle

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

e_funct: 
    li s1, 0x3F800000 # 1
    li s0, 0 # Charge n value
    fmv.w.x fs1, s1   # Charge first iteration in fs1 (current)
    fmv.w.x fs0, s0 # prev = 0
    fsub.s fs2, fs0, fs1 # Charge substraction of prev(fs0 = 0) and current(fs1)
    fabs.s fs2, fs2
	e_loop:
    	li s2, 0x3A83126F # error 
		fmv.w.x fs3, s2  # Charge error value in floating point (0.001)
        flt.s s2, fs2, fs3 # If substraction(fs2) is < to error(fs3) we stop
        bnez s2 end_s2
        addi s0, s0, 1 # counter(n/s0)++
        mv a0, s0
        fcvt.s.w fa0, a0 # Convert counter to float in order to perform factorial
        jal ra factorial
        
        fmv.w.x fs4, s1
        fdiv.s fs4, fs4, fa0 # divide fs4 = 1(fs4)/n!(fa0)
        fmv.s fs0, fs1 # prev = current
      	fadd.s fs1, fs1, fs4 # current = current + operation
      	fsub.s fs2, fs0, fs1 # sub_pc = prev - current
      	fabs.s fs2, fs2 # |sub_pc|
        j e_loop
        
        
        

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
      
			end_f:  fmv.s fa0, ft6 # result (fa0)
					jr ra

end_s1:  
		 # current to fa0
		# print sin(x)
        jal ra continue
		# exit

continue: fmv.s fa0, fs0
        li a7, 2
        ecall
        fmv.s ft0, fa0
        
        li a7, 4
        la a0, space
        ecall
        li a7, 4
        la a0, e
        ecall
        jal ra e_funct
        
end_s2: 
		fmv.s fa0, fs1
        # print e
        li a7, 2
        ecall
        li a7, 10
        ecall