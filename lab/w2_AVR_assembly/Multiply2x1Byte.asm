;
; Multiply2Byte.asm
;
; Created: 18-08-2024 11:48:46
; Author : Sanjeev S S B
;


; Replace with your application code
.CSEG
LDI ZL, LOW(VALS<<1)
LDI ZH, HIGH(VALS<<1)
LPM R16, Z+
LPM R17, Z
MUL	R16, R17
LDI XL, 0x60
LDI XH, 0x00
ST X+, R0
ST X, R1
NOP 

VALS: .db 0x32, 0x22;
