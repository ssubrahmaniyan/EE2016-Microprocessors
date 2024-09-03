;
; Blink_led_1hz.asm
;
; Author : Sanjeev S S B
;


; Replace with your application code
.include "m8def.inc"

.def ledtrig = r16; This is used to set the portB0 into output mode for glowing the led
.def ledR = r17; This register will be triggered and control the glowing of the led
.def outloopR = r18; This register can hold values between 0 and 255 to control the outer loop
.def inloopRH = r25; This register together can hold upto 2^16 - 1 values for the inner loop
.def inloopRL = r24; The two registers are addressed together as a word

.equ inloopC = 1760;
.equ outloopC = 71; This holds the number of iterations the loop should run for
; Here note that the total number of cycles taken is 4 + 4*outloopC*(inloopC + 1)
.cseg
reset:
	clr ledR
	ldi ledtrig, (1<<PINB0)
	out DDRB, ledtrig

start:
	eor ledR, ledtrig; This toggles the value of portB0 whenever this loop is performed
	out PORTB, ledR
	ldi outloopR, outloopC

outloop:
	ldi inloopRH, HIGH(inloopC)
	ldi inloopRL, LOW(inloopC)

inloop:
	sbiw inloopRL,1
	brne inloop; If the value of inloop is not zero, inloop is run again

	dec outloopR
	brne outloop; When the outer loop has also run down, both the values are reset

	rjmp start; Sends control back to start
