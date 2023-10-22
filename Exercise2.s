.text
SinMatrix:  # Address of matrix A: a0
			# Address of matrix B: a1
            # Number of rows N: a2
            # Number of columns M: a3
            # Push values into memory
            addi sp, sp, -32
            sw s6, 28(sp)
            sw s0, 24(sp)
            sw s1, 20(sp)
            sw s2, 16(sp)
            sw s3, 12(sp)
            sw s4, 8(sp)
            sw s5, 4(sp)
			sw ra, 0(sp)
            li s0, -1 # Initialize i = -1 (s0)
            li s2, 4 # Float size = 4 bytes
            loop_row:addi s0, s0, 1 # i++
            		 li s1, -1 # Initialize j = -1 (s1)
            		 bge s0, a2, end_SM # while i < N
                     loop_col:  addi s1, s1, 1 # j++
                     			bge s1, a3, loop_row # while j < M
                                mul s3, s0, a3 # i * M
                                add s3, s3, s1 # i * M + j
                                mul s3, s3, s2 # (i * M + j) * float size(4)
                                li s4, 0
                                add s4, s3, a0
                                flw fa0, 0(s4) # load A[i][j]
                                jal ra sin # sin(A[i][j])
                                li s5, 0
                                add s5, s3, a1
                                fsw fa0, 0(s5) # store sin(A[i][j]) in B[i][j]
                                j loop_col
            end_SM: # Pop values from memory
            		lw ra, 0(sp)
            		lw s5, 4(sp)
            		lw s4, 8(sp)
            		lw s3, 12(sp)
            		lw s2, 16(sp)
            		lw s1, 20(sp)
                    lw s0, 24(sp)
                    lw s6, 28(sp)
                    addi sp, sp, 32
                    #exit
                    jr ra
                     			
            
# x = A[i][j] fa0
sin:
	# Push values into memory
	addi sp, sp, -60 
    fsw fs0, 0(sp)
    fsw fs1, 4(sp)
    fsw fs2, 8(sp)
    fsw fs3, 12(sp)
    fsw fs4, 16(sp)
    fsw fs5, 20(sp)
    fsw fs6, 24(sp)
    fsw fs7, 28(sp)
    fsw fs8, 32(sp)
    sw s0, 36(sp)
    sw s1, 40(sp)
    sw s2, 44(sp)
    sw s3, 48(sp)
    sw s4, 52(sp)
    sw ra, 56(sp)
    fmv.s fs0, fa0    # Initialize current = x (current = fs0)
    fmv.s fs1, fa0
    li s0, 0 # n = 0
    fmv.w.x fa3, s0 # prev (fa3) = 0
    fsub.s fa1, fa3, fs0 # sub_pc = prev - current
    fabs.s fa1, fa1 # |sub_pc|
		
    sin_loop:
            # Check if sub_pc >= 0.001
            li s1, 1 # We calculate 1/1000 to insert 0.001 rest value
            fcvt.s.w fs2, s1
            li s2, 1000
            fcvt.s.w fs3, s2
            fdiv.s fs2, fs2, fs3
            flt.s s2, fa1, fs2 # Compare sub_pc con 0.001
            bnez s2, end_sin  # If sub_pc >= 0.001, continue in the loop

            # current = fa1, expo(x, 2*n + 1) = fs3, expo(-1, n) = fs4, factorial(2*n + 1) = fs8

            addi s0, s0, 1 #n++
            # expo(x: base = fa0, 2*n + 1: ex, a5)  = fs3
            li s3, 2
            mul s3, s0, s3 # 2*n
            addi a5, s3, 1 # 2*n + 1
            fmv.s fa0, fs1
            jal ra expo
            fmv.s fs3, fa0

            #expo(-1: base, fa0, n: ex, a5) = fs4
            li s4, 0xBF800000
            fmv.w.x fs4, s4
            fmv.s fa0, fs4 # -1
            mv a5, s0
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
            fmv.s fs8, fa0 # fs8 for factorial


            fmul.s ft1, fs3, fs4 # expo1 * expo2
            fdiv.s ft1, ft1, fs8 # expo1 * expo2 / factorial
            fmv.s fa3, fs0 # prev = current
            fadd.s fs0, ft1, fs0 # current = current + operation
            fsub.s fa1, fa3, fs0 # sub_pc = prev - current
            fabs.s fa1, fa1 # |sub_pc|
            j sin_loop
            
expo:	# ex = a5, fa0 = base
		beq a5, zero, end1 # if ex == 0 go to end1
		fmv.s fa1, fa0 # current = base
        li t1, 1
        
        while:	beq a5, t1, end2 # while (ex > 1)
        		fmul.s fa1, fa1, fa0 # current = current * base
                addi a5, a5, -1 # ex--
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
		flw fs0, 0(sp)
        flw fs1, 4(sp)
        flw fs2, 8(sp)
        flw fs3, 12(sp)
        flw fs4, 16(sp)
        flw fs5, 20(sp)
        flw fs6, 24(sp)
        flw fs7, 28(sp)
        flw fs8, 32(sp)
        lw s0, 36(sp)
        lw s1, 40(sp)
        lw s2, 44(sp)
        lw s3, 48(sp)
        lw s4, 52(sp)
        lw ra, 56(sp)
		addi sp, sp, 60
		# exit
        jr ra
    
    
