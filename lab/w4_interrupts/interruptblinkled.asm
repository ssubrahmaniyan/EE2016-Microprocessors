;The interrupt pin chosen to be used is INT0 = PD2
.include "m8def.inc"

.def ledR = r17
.def ledtrig = r16
.def outloopR = r18
.def inloopRL = r24
.def inloopRH = r25
.def mloopR = r20; This is used to control the led blinking

.equ inloopC = 1760;
.equ outloopC = 71; These two together will make the led with a frequency of 1Hz
.equ mloopC = 20; this makes sure the led toggles 20 times, for a total of 10 secs

.cseg
.org 0
rjmp reset; Jumps the interrupt vector table to the main program

.org 0x02
rjmp isr; Calls the ISR when the interrupt is triggered

.org 0x0100
reset:
	clr ledR
	ldi ledtrig, 0x01
	out DDRB, ledtrig; Sets port B0 as output for the led to be triggered
	ldi r31, 0x00
	out PORTB, r31
	ldi r19, HIGH(RAMEND)
	out SPH, r19
	ldi r19, LOW(RAMEND)
	out SPL, r19; Sets the stack pointer to hold the ISR
	sbi PORTD, 2
	ldi r19, 0x00; Sets portD as input only, which can then trigger the interrupt
	out DDRD, r19

	IN R30, MCUCR;Load MCUCR register 
	ORI R30, 0x00;
	OUT MCUCR, R30

	ldi r19, 0x40; can enable int0
	out GICR, r19; enables the interrupt pin
	sei; enables the interrupts
	
forever:
	rjmp forever ; puts the microcontroller in a loop waiting for the interrupt

isr: ; isr, which accomplishes the led blink as required
	clr ledR
	mloop:
		ldi mloopR, 20

	l1:
		ldi ledtrig, 0x01
		eor ledR, ledtrig
		out PORTB, ledR
		ldi outloopR, outloopC
	l2:
		ldi inloopRH, HIGH(inloopC)
		ldi inloopRL, LOW(inloopC)

	l3:
		sbiw inloopRL, 1
		brne l3

		dec outloopR
		brne l2

		dec mloopR
		brne l1

		ldi r31, 0x00
		out PORTB, r31 ; turns the led off after the ISR execution
		reti : return of control to the previously executing process
