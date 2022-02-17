;**************************************************************************
;Universitaet der Bundeswehr Muenchen
;02.12.2020 UN Version for VS-Code
;2011       Klaus Buchenrieder Initial version
;
;your comment
;
;**************************************************************************
/* The following is needed to subtract 0x20 from I/O addresses */ 
#define __SFR_OFFSET 0 

#include <avr/io.h>
#include <avr/iomxx0_1.h> 
;.include "m8def.inc"

;define a name for Register 16 and 17
#define TEMP R16
#define LED_COUNTER R17
#define FLAG R18


.global INT0_vect
INT0_vect:
    ;increment LED_COUNTER everytime interrupt is called
	cpi FLAG, 0x0
    breq stop_timer
    
    ;start timer and return
    ldi TEMP, (1<<CS12) | (1<<WGM12)
    sts TCCR1B, TEMP
    ldi FLAG, 0x0
    reti
    
    ;end timer and return
    stop_timer:
        ldi TEMP, (0<<CS12) | (1<<WGM12)
        sts TCCR1B, TEMP
        ldi FLAG, 1
    bla_test:
    ;nop
reti

.global TIMER1_COMPA_vect
TIMER1_COMPA_vect:
    inc LED_COUNTER
    com	LED_COUNTER			
    out PORTC,LED_COUNTER
	com LED_COUNTER
reti

.section .text
;set the startadress of the program to 0x40
.org 0x40 
;******************************* MAIN ************************************
.global main
main:
    cli;disable interrupts
    
    ser FLAG
    ;Data Direction Register DDR for Port C as Output
    ser TEMP
    out	DDRC, TEMP

    ;all LEDs off
    ser TEMP
    out PORTC, TEMP

    clr LED_COUNTER 

    ;ctc stuff
    ldi TEMP, (1<<CS12) | (1<<WGM12)
    sts TCCR1B, TEMP

    ldi TEMP, (1<<OCIE1A)
    sts TIMSK1, TEMP
    
    ldi TEMP, hi8(31250)
    sts OCR1AH, TEMP

    ldi TEMP, lo8(31250)
    sts OCR1AL, TEMP

    ;interrupt stuff
    ser TEMP
    out EIMSK, TEMP;clear interrupts

    ldi TEMP, 0x02  ;falling edge on INT0 triggers interrupt
    sts EICRA, TEMP
    
    ldi TEMP, 0x01
    out EIMSK, TEMP;enable INT0


    sei;enable interrupts
    ;endless loop
    _mloop:
    rjmp _mloop




