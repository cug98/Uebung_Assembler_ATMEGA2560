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

;define a name for Register 16 and 17
#define TEMP R16
#define LED_COUNTER R17


.global TIMER1_COMPA_vect
TIMER1_COMPA_vect:
    inc LED_COUNTER
    com	LED_COUNTER			
    out PORTC,LED_COUNTER
	com LED_COUNTER
reti

.section .text

;******************************* MAIN ************************************
.global main
main:
    cli
    ;ldi WGM, 0xff
    ;prescaler 256

    ;Data Direction Register DDR for Port C as Output
    ser TEMP
    out	DDRC, TEMP

    ;set 
    ldi TEMP, (1<<CS12) | (1<<WGM12)
    sts TCCR1B, TEMP

    ldi TEMP, (1<<OCIE1A)
    sts TIMSK1, TEMP
    
    ldi TEMP, hi8(31250)
    sts OCR1AH, TEMP

    ldi TEMP, lo8(31250)
    sts OCR1AL, TEMP

    ;all LEDs off
    ser TEMP
    out PORTC, TEMP

    sei
    
    ;ldi LED_COUNTER, 0x0F
    ;endless loop
    _mloop:
        sleep
        nop
    rjmp _mloop

