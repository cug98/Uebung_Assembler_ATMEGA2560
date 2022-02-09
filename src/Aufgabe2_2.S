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

.section .text

;******************************* MAIN ************************************
.global main
main:

    set WGMn, 0xff

    ;Data Direction Register DDR for Port C as Output
    ser TEMP
    out	DDRC, TEMP


    ;all LEDs off
    ser TEMP
    out PORTC, TEMP

    clr LED_COUNTER 



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
    
    rjmp _mloop

