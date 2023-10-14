.data
	one: .float 1.0
    cero: .float 0.0
    rest: .float 0.001
    minus_one: .float -1.0
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
    
		
sin_loop:
		# current = fa1, expo(x, 2*n + 1) = ft3, expo(-1, n) = ft4, factorial(2*n + 1) = a0
		addi a4, a4, 1 #n++
        # expo(x: base = fa0, 2*n + 1: ex, a3)  = ft3
		li t5, 2
        mul a3, t5, a4
        addi a3, a3, 1
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
        li t5, 2
        mul a0, t5, a4
        addi a0, a0, 1
        jal ra factorial

      fmul.s ft1, ft3, ft4 # expo1 * expo2
      fcvt.s.w ft0, a0 # a0 to float ft0
      fdiv.s ft1, ft1, ft0 # expo1 * expo2 / factorial
      fmv.s fa3, fa2 # prev = current
      fadd.s fa2, ft1, fa2 # current = current + operation
      fsub.s fa1, fa3, fa2 # sub_pc = prev - current
      fabs.s fa1, fa1 # |sub_pc|
    
    	# Comprueba si sub_pc >= 0.001
   		la t6, rest
    	flw ft7, 0(t6)
    	flt.s a5, fa1, ft7 # Compara sub_pc con 0.001
    	beqz a5, sin_loop   # Si sub_pc >= 0.001, continúa el bucle
		fmv.s fa0, fa2
    	jal ra end_s
		

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
			li t0, 1 # t0 for count
			li t1, 1 # t1 for result
			loop:   bgt t0, a0, end_f # a0 for num
					mul t1, t1, t0 # result = result * count
					addi t0, t0, 1 # count++
					j loop
      
			end_f:  mv a0, t1 # result (a0)
					jr ra

end_s:  # print sin(x)
        li a7, 2
        ecall
		# exit
        li a7, 10
        ecall