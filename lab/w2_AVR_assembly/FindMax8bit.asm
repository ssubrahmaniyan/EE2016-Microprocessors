;
; MaxFind8bit.asm
;
; Created: 18-08-2024 12:00:48
; Author : Sanjeev S S B
;

.CSEG
LDI ZL, LOW(VALS<<1)
LDI ZH, HIGH(VALS<<1)
LDI XL, 0x60
LDI XH, 0x00
LDI R16, 0x00; This will contain the maximum of the numbers and is hence initialized to zero
LDI R20, 0x06; This contains the number of values to iterate over

loop:
LPM R17, Z+
CP R17, R16
BRLO loop2
MOV R16, R17

loop2:
DEC R20
BRNE loop
RJMP did

did:
ST X, R16
RJMP done

done:
RJMP done


VALS: .db 0x12, 0x34, 0xaf, 0x53, 0x64, 0x43, 0x88
