.data 
 null_errorMessage: .asciiz "Input is empty."
 length_errorMessage: .asciiz "Input is too long."
 base_errorMessage: .asciiz "Invalid base-35 number."
 user_Input: .space 1000
 .text
main:
 li $v0, 8 
 la $a0, user_Input 
 li $a1, 1000
 syscall 
 addi $sp, $sp, -8
 sw $a0, 4($sp)
 sw $ra, 0($sp) 
 jal userInput_loop
 lw $t8, 0($sp) 
 addi $sp, $sp, 4 
 addi $sp, $sp, -8 
 sw $t8, 4($sp) 
 sw $ra, 0($sp)
 jal Totalsum
 j end
userInput_loop:
 addi $sp, $sp, -4
 sw $ra, 0($sp) 
 jal remove_leading_spaces
 jal removespaceafter
 jal checkLength
 lw $ra, 4($sp) 
 lw $t8, 0($sp)
 addi $sp, $sp, 8 
 addi $sp, $sp, -4
 sw $t8, 0($sp) 
 jr $ra 
remove_leading_spaces:
 li $t8, 32 
 lw $a0, 8($sp)
removespaceinfront: 
 lb $t7, 0($a0) 
 beq $t8, $t7, removefirstcharacter 
 move $t7, $a0 
 jr $ra
removefirstcharacter:
 addi $a0, $a0, 1
 j removespaceinfront
removespaceafter:
 la $t2, user_Input
 sub $t2, $t7, $t2 
 li $t1, 0 
 li $t8, 0 
removespaceafter_loop:
 add $t4, $t2, $t8
 addi $t4, $t4, -1000
 beqz $t4, end_removespaceafter 
 add $t4, $t8, $a0
 lb $t4, 0($t4) 
 beq $t4, $zero, end_removespaceafter 
 addi $t4, $t4, -10
 beqz $t4, end_removespaceafter 
 addi $t4, $t4, -22
 bnez $t4, updatelastIndex 
removespaceafter_increment:
 addi $t8, $t8, 1 
 j removespaceafter_loop
updatelastIndex:
 move $t1, $t8 
 j removespaceafter_increment
end_removespaceafter:
 add $t4, $zero, $a0 
 add $t4, $t4, $t1 
 addi $t4, $t4, 1 
 sb $zero, 0($t4) 
 jr $ra
checkLength:
 li $t0, 0
 add $a0, $t7, $zero
 lb $t2, 0($a0)
 addi $t2, $t2, -10 
 beq $t2, $zero, null_error 
checkLength_Loop:
 lb $t2, 0($a0)
 or $t1, $t2, $t0
 beq $t1, $zero, null_error
 beq $t2, $zero, stringDone
 addi $a0, $a0, 1
 addi $t0, $t0, 1
 j checkLength_Loop
stringDone:
 slti $t5, $t0, 5
 beq $t5, $zero, length_error
 bne $t5, $zero, check_String
null_error:
 li $v0, 4
 la $a0, null_errorMessage
 syscall
 j end
length_error:
 li $v0, 4
 la $a0, length_errorMessage
 syscall
 j end
check_String:
 move $a0, $t7 
check_StringLoop:
 li $v0, 11
 lb $t3, 0($a0)
 move $t8, $a0
 move $a0, $t3
 move $a0, $t8
 li $t8, 10 
 beq $t3, $zero, base_converter
 slti $t4, $t3, 48 
 bne $t4, $zero, base_error
 slti $t4, $t3, 58 
 bne $t4, $zero, Increment
 slti $t4, $t3, 65 
 bne $t4, $zero, base_error 
 slti $t4, $t3, 90 
 bne $t4, $zero, Increment
 slti $t4, $t3, 97 
 bne $t4, $zero, base_error 
 slti $t4, $t3, 122 
 bne $t4, $zero, Increment
 bgt $t3, 121, base_error 
 li $t8, 10 
 beq $t3, $t8, base_converter 
Increment:
 addi $a0, $a0, 1
 j check_StringLoop
base_error:
 li $v0, 4
 la $a0, base_errorMessage
 syscall
 j end
base_converter:
 move $a0, $t7 
 li $t2, 10
 li $t8, 0 
 add $s7, $s7, $t0
 addi $s7, $s7, -1 
 li $s2, 3
 li $s3, 2
 li $s6, 1
 li $s1, 0
convertString: 
 lb $s5, 0($a0)
 beqz $s5, Totalsum	
 beq $s5, $t2, Totalsum 
 slti $t4, $s5, 58 
 bne $t4, $zero, zero_to_nine
 slti $t4, $s5, 86 
 bne $t4, $zero, A_to_Y
 slti $t4, $s5, 122 
 bne $t4, $zero, a_to_y
zero_to_nine:
 addi $s5, $s5, -48
 j next_step
A_to_Y:
 addi $s5, $s5, -55
 j next_step
a_to_y:
 addi $s5, $s5, -87
next_step:
 beq $s7, $s2, Base_raised_toThree
 beq $s7, $s3, Base_raised_toTwo
 beq $s7, $s6, Base_raised_toOne
 beq $s7, $s1, Base_raised_toZero
Base_raised_toThree:
 li $s4, 42875
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
 addi $s7, $s7, -1
 addi $a0, $a0, 1
 j convertString
Base_raised_toTwo:
 li $s4, 1225
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
 addi $s7, $s7, -1
 addi $a0, $a0, 1
 j convertString
Base_raised_toOne:
 li $s4, 35
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
 addi $s7, $s7, -1
 addi $a0, $a0, 1
 j convertString
Base_raised_toZero:
 li $s4, 1
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
Obtained_value:
 addi $sp, $sp, -4
 sw $t8, 0($sp) 
 jr $ra 
Totalsum:
 li $v0, 1
 lw $a0, 4($sp) 
 syscall
 jr $ra
end:
 li $v0,10 
 syscall
