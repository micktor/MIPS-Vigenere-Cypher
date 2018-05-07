# Mark Mileyev

########## Pseudocode ###########
# EC: Subtract key by 65, then add that to the message
# DC: Subtract key by 65, then subtract from message
# ES: interate a0,a1,a2
# 	Run EC if valid input,
#		a0, a1, a2  ++
# DS: interate a0,a1,a2
# 	Run DC if valid input,
#		a0, a1, a2  ++
########## End Pseudocode ###########



EncryptString:
sw $ra, ($sp) #store return address
subi $sp, $sp, 4
		beqz $t6, __iflt1
		__allg1:
		#addi, $t6, $t6, 97 #store 97 to check for ASCII 90 < x < 97
		addi $t7, $t7, 123
		
		#addi $t8, $t8, 0 #counter for loop
		#addi $t9, $t9, 1 #increment loop
		
		la $t0, ($a0)
		la $t1, ($a1)
		la $t3, ($a1)
		la $t2, ($a2)
		__loop:
		#bgt, $t8, 30, __quit
		#add $t8, $t8, $t9 #counter for loop
		
		lb $a0, ($t0)
		lb $a1, ($t1)
		lb $a2, ($t2)
			beqz $a0, __quit
			beqz $a1, __reset #if key runs out, go back to beginning
			
			blt $a0, 65, __skip #if less that 65 (A) skip that shit
			
			sgt $t4, $a0, 90  # 90 < x
			slt $t5, $a0, $t6 # x < 97
			and $t4, $t4, $t5 # If both are true
			bnez $t4, __skip # 90 < x < 97 (Z)
			
			bgt $a0, 122, __skip
			
			jal EncryptChar
			addi $t0, $t0, 1
			addi $t1, $t1, 1
			sb $v0, ($t2)
			addi $t2, $t2, 1
			
			j __loop
			
	__reset:
	la $t1, ($t3)	
	j __loop
	
	__skip:
	sb $a0, ($t2)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j __loop

	__quit: 
	la $t2, ($a2)
	addi $sp, $sp, 4 #return to calling code
	lw $ra, ($sp)
	jr $ra
		
EncryptChar:
	
	blt $a0, 97, __upper
	
	addi $a0, $a0, -97
	addi $a1, $a1, 32
	add $v0, $a0, $a1
	bgt $v0, 122, __Overflow1
	jr $ra
		__Overflow1:
		addi $v0, $v0, -26
		jr $ra
	
	__upper:
	addi $a0, $a0, -65
	add $v0, $a0, $a1
	bgt $v0, 90, __Overflow
	jr $ra
		__Overflow:
		addi $v0, $v0, -26
		jr $ra
		
		
DecryptString:
sw $ra, ($sp) #store return address
subi $sp, $sp, 4
		beqz $t6, __iflt2
		__allg2:
		#addi, $t6, $t6, 97 #store 97 to check for ASCII 90 < x < 97
		addi $t7, $t7, 123
		la $t0, ($a0)
		la $t1, ($a1)
		la $t3, ($a1)
		la $t2, ($a2)
		__loopDS:
		lb $a0, ($t0)
		lb $a1, ($t1)
		lb $a2, ($t2)
			beqz $a0, __quitDS
			beqz $a1, __resetDS #if key runs out, go back to beginning
			
			blt $a0, 65, __skipDS #if less that 65 (A) skip that shit
			
			sgt $t4, $a0, 90  # 90 < x
			slt $t5, $a0, $t6 # x < 97
			and $t4, $t4, $t5 # If both are true
			bnez $t4, __skipDS # 90 < x < 97 (Z)
			
			bgt $a0, 122, __skipDS
			
			jal DecryptChar
			addi $t0, $t0, 1
			addi $t1, $t1, 1
			sb $v0, ($t2)
			addi $t2, $t2, 1
			
			j __loopDS
			
	__resetDS:
	la $t1, ($t3)	
	j __loopDS
	
	__skipDS:
	sb $a0, ($t2)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j __loopDS

	__quitDS: 
	la $t2, ($a2)
	addi $sp, $sp, 4 #return to calling code
	lw $ra, ($sp)
	jr $ra
		
	
DecryptChar:
	
	blt $a0, 97, __upper1

	addi $a1, $a1, -65
	#addi $a1, $a1, 32
	sub $v0, $a0, $a1
	blt $v0, 97, __Underflow1
	jr $ra
		__Underflow1:
		addi $v0, $v0, +26
		jr $ra

	__upper1:
	addi $a1, $a1, -65
	sub $v0, $a0, $a1
	blt $v0, 65, __Underflow
	jr $ra
		__Underflow:
		addi $v0, $v0, +26
		jr $ra
		
		
		
__iflt1:
		addi $t6, $t6, 97 #check for lowercase
		j __allg1
		
__iflt2:
		addi $t6, $t6, 97 #check for lowercase
		j __allg2
