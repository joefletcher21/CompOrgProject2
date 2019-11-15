.data 
   null_errorMessage:   .asciiz  "Input is empty."
   length_errorMessage:   .asciiz  "Input is too long."
   base_errorMessage:   .asciiz   "Invalid base-35 number."
   user_Input:   .space 1000
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
