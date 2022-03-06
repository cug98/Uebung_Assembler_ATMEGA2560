;**************************************************************************
;Universitaet der Bundeswehr Muenchen
;02.12.2020 UN Version for VS-Code
;2011       Klaus Buchenrieder Initial version
;
;Berechnung für den Wert von OCR1:
;       8.000.000 Takte = 500 ms  
;       Prescaler 256 
;       8.000.000 / 256 = 31.250
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

;Definiert Interruptvektor für den Timer-Vergleich -> LED umschalten
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
    ;Aktiviert Interuptsperre
    cli
    
    ;Vorbereitung für die LED-Steuerung
    ser TEMP
    out	DDRC, TEMP
    ser TEMP
    out PORTC, TEMP
    clr LED_COUNTER

    ;Setzt den Prescaler auf 256 (CS12) und aktiviert CTC-Modus (WGM12) 
    ldi TEMP, (1<<CS12) | (1<<WGM12)
    sts TCCR1B, TEMP

    ;Setzt die Interruptmaske für den Timer1-Vergleich
    ldi TEMP, (1<<OCIE1A)
    sts TIMSK1, TEMP
    
    ;Belegt die Vergleichsregister mit dem Wert 31250
    ldi TEMP, hi8(31250)
    sts OCR1AH, TEMP
    ldi TEMP, lo8(31250)
    sts OCR1AL, TEMP

    ;Deaktiviert Interruptsperre
    sei

   ;Endlosschleife 
    _mloop:
    rjmp _mloop
