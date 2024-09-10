.include "m8def.inc"

start:
	.cseg	
	.org	0x00

	ldi r16, 0x00; load pinb0 to r16
	out DDRB,r16 ;setting it to input

check_input:
	

	IN r16, PINB
	COM r16
	mov r17, r16
	mov r18, r16

	ANDI R17, 0x0F  
	ANDI R18, 0XF0

	LSR R18
	LSR R18
	LSR R18
	LSR R18

	add r17, r18

	ldi r16, 0xFF
	OUT DDRD, r16
	OUT PORTD, r17
	rjmp check_input



