;**************************************************************************
;Universitaet der Bundeswehr Muenchen
;02.12.2020 UN Version for VS-Code
;2011   Klaus Buchenrieder Initial version
;   
;Berechnung für wait_10ms:
;   160.000 Takte = 10 ms
;   10 Instruktionen in wait_10ms -> Zählen bis 16.000
;   Binärdarstellung 16.000 -> 11111010000000
;   Aufteilung von 16.000 auf Register R24 und R25
;   R25 hält den höherwertigen Byte -> 11111010 also Dezimal 250     
;
; Abgabe von Übungsgruppe 1, Gruppe 9:
; Maximilian Filzer, Matrikelnummer: 1196756
; Christian Galda, Matrikelnummer: 1224466
;**************************************************************************
/* The following is needed to subtract 0x20 from I/O addresses */ 
#define __SFR_OFFSET 0 

#include <avr/io.h>

;Definiere Register
#define TEMP R16
#define LED_COUNTER R17

.section .text

;******************************* MAIN ************************************
.global main
main:

    ;Vorbereitung für die LED-Steuerung
    ser TEMP
    out	DDRC, TEMP
    ser TEMP
    out PORTC, TEMP
    clr LED_COUNTER 

    ;Endlosschleife
    _mloop:
        ;Schaltet LEDs um
    	com	LED_COUNTER				
	    out PORTC,LED_COUNTER
	    com LED_COUNTER
	    inc LED_COUNTER

        ;Ruft die 500ms Vezögerung auf
        call wait_500ms
    rjmp _mloop

;Alle 10 Takte Eins in R24 bzw. R25 hochzählen
wait_10ms:
    ;Register werden gespeichert und genullt
    push R24
    push R25
    push R21
    clr R24
    clr R25
    clr R21
    
    ;250 Dezimal (0xFA) wird in R21 geladen 
    ldi R21, 0xFA

    ;Schleife läuft so lange bis 160.000 Takte erreicht wurden 
    _start_loop:
        adiw R24, 0x1 
        cp R25, R21
    brge _start_loop 
    
    ;Register werden wiederhergestellt
    pop R21
    pop R25
    pop R24
    ret

wait_500ms:
    ;Register werden gespeichert und genullt
    push r20
    push r21
    clr r20
    clr r21

    ;Wert 50 wird in R20 geladen
    ldi r20, 0x32 

    ;Schleife ruft 50-mal wait_10ms auf
    loop_500:
        call wait_10ms
        inc r21
        cp r21, r20
    brne loop_500

    ;Register werden wiederhergestellt
    pop r21
    pop r20
    ret