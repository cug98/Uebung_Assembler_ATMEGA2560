;**************************************************************************
;Universitaet der Bundeswehr Muenchen
;02.12.2020 UN Version for VS-Code
;2011        Klaus Buchenrieder Initial version
;
;Switch0 FLAG Logik:
;   FLAG==0 -> Timer läuft
;   FLAG==1 -> Timer gestoppt
;
; Abgabe von Übungsgruppe 1, Gruppe 9:
; Maximilian Filzer, Matrikelnummer: 1196756
; Christian Galda, Matrikelnummer: 1224466
;**************************************************************************
/* The following is needed to subtract 0x20 from I/O addresses */ 
#define __SFR_OFFSET 0 

#include <avr/io.h>
#include <avr/iomxx0_1.h> 

;Definiere Register
#define TEMP R16
#define LED_COUNTER R17
#define FLAG R18

;Definiere Interruptvektor für Switch0
.global INT0_vect
INT0_vect:
    ;Vergleiche FLAG mit Null
	cpi FLAG, 0x0
    breq stop_timer
    
    ;Startet Timer mit High in CS12 und löscht FLAG
    ldi TEMP, (1<<CS12) | (1<<WGM12)
    sts TCCR1B, TEMP
    ldi FLAG, 0x0
    reti
    
    ;Stoppt den Timer mit Low in CS12 und setzt FLAG
    stop_timer:
        ldi TEMP, (0<<CS12) | (1<<WGM12)
        sts TCCR1B, TEMP
        ldi FLAG, 1
reti

;Definiert Interruptvektor für den Timer-Vergleich -> LED umschalten
.global TIMER1_COMPA_vect
TIMER1_COMPA_vect:
    inc LED_COUNTER
    com	LED_COUNTER			
    out PORTC,LED_COUNTER
	com LED_COUNTER
    reti

.section .text

;Setzt die Startadresse des Programms auf 0x40
.org 0x40 
;******************************* MAIN ************************************
.global main
main:
    ;Aktiviert Interuptsperre
    cli
    
    ;Initialisiere FLAG mit Null
    ser FLAG

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

    ;aktiviere INT0
    ldi TEMP, 0x01
    out EIMSK, TEMP

    ;Deaktiviert Interruptsperre
    sei

    ;Endlosschleife
    _mloop:
    rjmp _mloop




