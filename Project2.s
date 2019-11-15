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
