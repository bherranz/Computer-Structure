.data
	# In this section we will print the result given by each function(sin, cosine, tg, e)
    msg1: .string "Exercise 1: 
    "
    
.text
main:
	li a7, 4    # We print the first message
    la a0, msg1
    ecall
    li a0, 2
    jal ra exp1
    li a7, 1
    ecall
    li a7, 10
    ecall
    
    exp1:
    	addi sp, sp, -20
    	sw s0, 0(sp)
        sw s1, 4(sp)
        sw s2, 8(sp)
        sw s3, 12(sp)
        sw ra, 16(sp)
    	li s0, -1
        li s1, -1
        li s2, 1
        mv s3, a0
  
        while: 
        	bge s2, s3 end
            mul a0, s0, s1
            addi s2, s2, 1
            j while
        end:
        	lw s0, 0(sp)
            lw s1, 4(sp)
            lw s2, 8(sp)
            lw s3, 12(sp)
            lw ra, 16(sp)
            addi sp, sp, 20
        	jr ra
        	
        
    
        
    	