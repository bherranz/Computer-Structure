.text
sin:
	# Push values into memory
	addi sp, sp, -60 
    fsw fs0, 56(sp)
    fsw fs1, 52(sp)
    fsw fs2, 48(sp)
    fsw fs3, 44(sp)
    fsw fs4, 40(sp)
    fsw fs5, 36(sp)
    fsw fs6, 32(sp)
    fsw fs7, 28(sp)
    fsw fs8, 24(sp)
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s4, 4(sp)
    sw ra, 0(sp)
    fmv.s fs0, fa0    # Initialize current = x (current = fs0)
    fmv.s fs1, fa0
    li s0, 0 # n = 0
    fcvt.s.w fa3, s0 # prev (fa3) = 0
    fsub.s fa1, fa3, fs0 # sub_pc = prev - current
    fabs.s fa1, fa1 # |sub_pc|
		
    sin_loop:
            # Check sub_pc >= 0.001
            li s1, 1 # We calculate 1/1000 to insert 0.001 rest value
            fcvt.s.w fs2, s1
            li s2, 1000
            fcvt.s.w fs3, s2
            fdiv.s fs2, fs2, fs3
            flt.s s2, fa1, fs2 # Compare sub_pc con 0.001
            bnez s2, end_sin  # If sub_pc >= 0.001, continue in the loop

            # current = fa1, expo(x, 2*n + 1) = fs3, expo(-1, n) = fs4, factorial(2*n + 1) = fs8

            addi s0, s0, 1 #n++
            # expo(x: base = fa0, 2*n + 1: ex, a1)  = fs3
            li s3, 2
            mul s3, s0, s3 # 2*n
            addi a1, s3, 1 # 2*n + 1
            fmv.s fa0, fs1
            jal ra expo
            fmv.s fs3, fa0

            #expo(-1: base, fa0, n: ex, a1) = fs4
            li s4, 0xBF800000
            fmv.w.x fs4, s4
            fmv.s fa0, fs4 # -1
            mv a1, s0
            jal ra expo
            fmv.s fs4, fa0

            # factorial (2*n + 1) = fs8
            li t1, 0x40000000
            fmv.w.x fs5, t1 # 2 in floating point
            fcvt.s.w fs6, s0 # fs6 = s0(n)
            fmul.s fa0, fs5, fs6 # 2*n
            li t1, 0x3F800000 
            fmv.w.x fs7, t1	 # load 1 in floating point
            fadd.s fa0, fa0, fs7 # 2*n + 1
            jal ra factorial
            fmv.s fs8, fa0 # fs8 for factorial


            fmul.s ft1, fs3, fs4 # expo1 * expo2
            fdiv.s ft1, ft1, fs8 # expo1 * expo2 / factorial
            fmv.s fa3, fs0 # prev = current
            fadd.s fs0, ft1, fs0 # current = current + operation
            fsub.s fa1, fa3, fs0 # sub_pc = prev - current
            fabs.s fa1, fa1 # |sub_pc|
            j sin_loop

cos:
	# Push values into memory
	addi sp, sp, -56 
    fsw fs0, 52(sp)
    fsw fs1, 48(sp)
    fsw fs2, 44(sp)
    fsw fs3, 40(sp)
    fsw fs4, 36(sp)
    fsw fs5, 32(sp)
    fsw fs6, 28(sp)
    fsw fs7, 24(sp)
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s4, 4(sp)
    sw ra, 0(sp)
    
    li t1, 0x3F800000
    fmv.w.x fs0, t1    # Initialize current = 1 (current = fs0)
    fmv.s fs1, fa0
    li s0, 0 # n = 0
    fcvt.s.w fa3, s0 # prev (fa3) = 0
    fsub.s fa1, fa3, fs0 # sub_pc = prev - current
    fabs.s fa1, fa1 # |sub_pc|
		
    cos_loop:
            # Check if sub_pc >= 0.001
            li s1, 1 # We calculate 1/1000 to insert 0.001 rest value
            fcvt.s.w fs2, s1
            li s2, 1000
            fcvt.s.w fs3, s2
            fdiv.s fs2, fs2, fs3
            flt.s s2, fa1, fs2 # Compare sub_pc with 0.001
            bnez s2, end_cos  # If sub_pc >= 0.001, continue in the loop

            # current = fs0, expo(x, 2*n) = fs3, expo(-1, n) = fs4, factorial(2*n) = fs8

            addi s0, s0, 1 #n++
            # expo(x: base = fa0, 2*n: ex, a1)  = fs3
            li s3, 2
            mul a1, s0, s3 # 2*n
            fmv.s fa0, fs1
            jal ra expo
            fmv.s fs3, fa0

            #expo(-1: base, fa0, n: ex, a1) = fs4
            li s4, 0xBF800000
            fmv.w.x fs4, s4
            fmv.s fa0, fs4 # -1
            mv a1, s0
            jal ra expo
            fmv.s fs4, fa0

            # factorial (2*n) = fa0
            li t1, 0x40000000
            fmv.w.x fs5, t1 # 2 in floating point
            fcvt.s.w fs6, s0
            fmul.s fa0, fs5, fs6 # 2*n
            jal ra factorial
            fmv.s fs7, fa0 # ft0 for factorial


            fmul.s ft1, fs3, fs4 # expo1 * expo2
            fdiv.s ft1, ft1, fs7 # expo1 * expo2 / factorial
            fmv.s fa3, fs0 # prev = current
            fadd.s fs0, fs0, ft1 # current = current + operation
            fsub.s fa1, fa3, fs0 # sub_pc = prev - current
            fabs.s fa1, fa1 # |sub_pc|
            j cos_loop

tg: # Push
    addi sp, sp, -36
    fsw fs0, 32(sp)
    fsw fs1, 28(sp)
    fsw fs2, 24(sp)
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    fsw fs3, 4(sp)
    sw ra, 0(sp)
    # Calculate 1/1000 to insert 0.001 rest value
    li s0, 1 
    fcvt.s.w fs0, s0
    li s3, 1000
    fcvt.s.w fs3, s3
    fdiv.s fs0, fs0, fs3
    # store x in fs1
	fmv.s fs1, fa0
    # cos(x)
    jal ra cos
    fmv.s fs2, fa0
    fle.s s2, fs2, fs0  # If cos(x)/fs2 is <= 0.001(fs0) we do not perform operation 
    bnez s2 end_tg2
    fmv.s fa0, fs1
    # sin(x)
    jal ra sin
    fmv.s fs3, fa0
    # sin(x)/cos(x)
    fdiv.s fa0, fs3, fs2
    j end_tg
    end_tg2:
    	li s3, 0x7F800000 # +inf
        fmv.w.x fa0, s3
    end_tg:
    	# Pull
    	lw ra, 0(sp)
        flw fs3, 4(sp)
        lw s3, 8(sp)
        lw s2, 12(sp)
        lw s1, 16(sp)
        lw s0, 20(sp)
        flw fs2, 24(sp)
        flw fs1, 28(sp)
        flw fs0, 32(sp)
        addi sp, sp, 36
    	jr ra
    	

e_funct: 
	# Push elements into memory
	addi sp, sp, -36
    sw ra 32(sp)
    fsw fs4 28(sp)
    fsw fs3 24(sp)
    fsw fs2 20(sp)
    fsw fs1 16(sp)
    fsw fs0 12(sp)
    sw s2 8(sp)
    sw s1 4(sp)
    sw s0 0(sp)
    
    li s1, 0x3F800000
    li s0, 0 # Charge n value
    fcvt.s.w fs0, s0 # prev (fs0) = 0
    fmv.w.x fs1, s1   # Charge first iteration in fs1 (current)
    fsub.s fs2, fs0, fs1 # Charge subtraction of prev(fs0 = 0) and current(fs1)
    fabs.s fs2, fs2
	e_loop:
    	li s2, 0x3A83126F
		fmv.w.x fs3, s2  # Charge error value in floating point (0.001)
        flt.s s2, fs2, fs3 # If subtraction(fs2) is <= to error(fs3) we stop
        bnez s2 end_e
        
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
        		j end_expo
        end2: fmv.s fa0, fa1 # return current(fa0)
        end_expo: jr ra

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

end_sin: 
		fmv.s fa0, fs0 # current to fa0
        # Pop values from memory
		lw ra, 0(sp)
        lw s4, 4(sp)
        lw s3, 8(sp)
        lw s2, 12(sp)
        lw s1, 16(sp)
        lw s0, 20(sp)
        flw fs8, 24(sp)
        flw fs7, 28(sp)
        flw fs6, 32(sp)
        flw fs5, 36(sp)
        flw fs4, 40(sp)
        flw fs3, 44(sp)
        flw fs2, 48(sp)
        flw fs1, 52(sp)
        flw fs0, 56(sp)
		addi sp, sp, 60
		# exit
        jr ra

end_cos: 
		fmv.s fa0, fs0 # current to fa0
        # Pop values from memory
		lw ra, 0(sp)
        lw s4, 4(sp)
        lw s3, 8(sp)
        lw s2, 12(sp)
        lw s1, 16(sp)
        lw s0, 20(sp)
        flw fs7, 24(sp)
        flw fs6, 28(sp)
        flw fs5, 32(sp)
        flw fs4, 36(sp)
        flw fs3, 40(sp)
        flw fs2, 44(sp)
        flw fs1, 48(sp)
        flw fs0, 52(sp)
        addi sp, sp, 56
		# exit
        jr ra

        
end_e: 
		fmv.s fa0, fs1 # current to fa0
        # Pop elements from memory
		lw s0 0(sp)
        lw s1 4(sp)
        lw s2 8(sp)
        flw fs0 12(sp)
        flw fs1 16(sp)
        flw fs2 20(sp)
        flw fs3 24(sp)
        flw fs4 28(sp)
        lw ra 32(sp)
		addi sp, sp, 36
        # exit
        jr ra