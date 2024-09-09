.include "m8def.inc"

start:
	.cseg	
	.org	0x00

	ldi r16, 0x00; load pinb0 to r16
	out DDRB,r16 ;setting it to input

check_input:
	

	SBIS PINB, 0;0-> switch on 
	rjmp light_led

	ldi r17, 0x0
	OUT PORTD, r17
	rjmp check_input

light_led:
	ldi r16, 0xFF
	OUT DDRD, r16
	ldi r17, 0x1
	OUT PORTD, r17
	rjmp check_input
