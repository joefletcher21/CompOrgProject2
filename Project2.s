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
