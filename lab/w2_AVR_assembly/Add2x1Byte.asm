;
; Add2Bytes.asm
;
; Created: 18-08-2024 11:27:36
; Author : Sanjeev S S B
;


; Replace with your application code
.CSEG			;Indicates the beginning of program memory, the lines after this will be written to the code segment of the memory
LDI ZL, LOW(VALS<<1)
LDI ZH, HIGH(VALS<<1) ;These two lines load the high and low bytes of the address of VALS into the pointer register Z
LPM R16, Z+ ;This loads the value held by the address Z into the register R16 and increments the address to Z + 1
LPM R17, Z ;This loads the current value of Z, which is the second number to be added
LDI XL, 0x60;
LDI XH, 0x00 ;Defines the memory location in RAM to store the final added output
ADD R16, R17; Adds the values in the R16, R17 and places the results in R16
ST X, R16 ;Store the value held in R16, which is the sum of the two numbers into the first non-register memory location in the RAM
NOP ;Signifies the end of the program operation
VALS: .db 0x12, 0x34 ;Stores the two bytes in a contiguous memory location whose address is VALS

