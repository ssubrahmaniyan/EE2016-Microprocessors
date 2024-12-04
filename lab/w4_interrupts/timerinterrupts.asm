.include "m8def.inc"
.cseg
.org 0
rjmp 0x0100

.org 0x0100
ldi r16, LOW(RAMEND)
out spl, r16
ldi r16, HIGH(RAMEND)
out sph, r16

; Configure PB5 as output
ldi r24, 0x20
sbi ddrb, 5 ; sets pb5 as the LED pin
ldi r17, 0
out portb, r17 ; initially sets the LED off

; Initialize Timer1 with a start value
ldi r20, 0x5f ; High byte of initial counter value
out tcnt1h, r20
ldi r20, 0xf8 ; Low byte of initial counter value
out tcnt1l, r20

; Configure Timer1 in normal mode with a prescaler of 256
ldi r16, 0x00
out tccr1a, r16 ; Timer1 in normal mode
ldi r16, 0x04
out tccr1b, r16 ; prescaler set to 256

; Enable overflow interrupt for Timer1
ldi r16, (1<<TOIE1)
out timsk, r16

; Enable global interrupts
sei

start:
    rjmp start ; Main loop, does nothing as LED toggling is handled by ISR

; Interrupt Service Routine for Timer1 overflow
.org OC1Aaddr
timer1_ovf_isr:
    eor r17, r24 ; Toggle the state of PB5 (LED)
    out portb, r17

    ; Reset Timer1 to initial value 1593 (high = 0x5F, low = 0xF8)
    ldi r20, 0x5f ; High byte of initial counter value
    out tcnt1h, r20
    ldi r20, 0xf8 ; Low byte of initial counter value
    out tcnt1l, r20

    reti ; Return from interrupt
