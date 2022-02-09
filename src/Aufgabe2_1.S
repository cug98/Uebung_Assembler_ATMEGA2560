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
        call wait_500ms
    rjmp _mloop


wait_10ms:
    push R24
    push R25
    push R21
    clr R24
    clr R25
    clr R21
    ldi R21, 0x9c
    _start_loop:
        adiw R24, 0x1
        cp R25, R21
        brge _start_loop 
    pop R21
    pop R25
    pop R24
    ret

wait_500ms:
    push r20
    push r21
    clr r20
    clr r21
    ldi r20, 0x32
    loop_500:
        call wait_10ms
        inc r21
        cp r21, r20
    brne loop_500
    pop r21
    pop r20
ret