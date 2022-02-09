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
#define TICKER R18
#define TICKER2 R19
#define REGFULL r20
#define TICKER3 r21
#define IMM50 r22

.section .text

;******************************* MAIN ************************************
.global main
main:

    ;Data Direction Register DDR for Port C as Output
    ser TEMP
    out	DDRC, TEMP

    ldi REGFULL, 0x9c

    ;all LEDs off
    ser TEMP
    out PORTC, TEMP

    clr LED_COUNTER 



    call wait_10ms
    ;endless loop
    _mloop:
        ;One’s Complement
    	com	LED_COUNTER			
        ;set PORTC	
	    out PORTC,LED_COUNTER
        ;One’s Complement
	    com LED_COUNTER
        ;increment LED_COUNTER
	    inc LED_COUNTER
        call wait_500ms
    
    rjmp _mloop

;wait_10ms:
;    	cpi r20,160000
;        brne


wait_10ms:
    inc TICKER

    brvs _overflow

_compare:
    cp TICKER2,REGFULL

    brne wait_10ms

    clr TICKER2
ret


_overflow:
    inc TICKER2
rjmp _compare

wait_500ms:
    push r20
    clr TICKER3
    ldi IMM50, 0x32
    loop_500:
        call wait_10ms
        inc TICKER3
        cp TICKER3, IMM50
    brne loop_500
    pop r20
ret