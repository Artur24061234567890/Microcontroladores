/*
    Uso de interrupciones para alternar el encendido de dos leds
*/
    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL ;4MHz es 4 con 6ceros
	
    PSECT code, reloc=2, abs
    
    var1	equ	500H ;cada que nombremos var1 haremos referencia al banco 5 posición 00H
    var2	equ	501H
    var3	equ	503H	
 
    ORG     000000H
    goto    configuro
    
    ORG	    000008H
    goto    ISR_HP	;interrupciones de alta prioridad
    
    ORG	    000018H
    goto    ISR_LP	;interrupciones de baja prioridad
    
    ORG	    000020H
    
configuro:
    ; oscilador
    movlb    00H	    ;banco 0(OSCON1 OSCFRQ OSCEN)
    movlw    60H    
    movwf    OSCCON1, b	    ;HFINTOSC y NDIV 1
    movlw    02H    
    movwf    OSCFRQ, b	    ;4MHz
    movlw    40H    
    bcf	    TRISD, 0, b	    ;output
    bcf	    ANSELD, 0, b    ;digital
    bsf	    LATD, 0, b	    ;activado
    ; RB0
    bsf	    TRISB, 0, b	    ;input
    bcf	    ANSELB, 0, b    ;digital
    bsf	    WPUB, 0, b	    ;pull-up
    ; interrupciones
    bsf	    INTCON0, 5, b   ;se activa los niveles de prioridad
    bsf	    INTCON0, 7, b   ;GIEH: interrupciones de alta prioriad activadas
    bcf	    INTCON0, 0, b   ;la interrupción en INT0 ocurrirá al detectar un 0 (flanco bajada)
    bsf	    PIE1, 0, b	    ;está activando la interrupción del grupo 1 bit0 (INT0)
    movlb   03H		    ;banco 3(IPRx)
    bsf	    IPR1, 0, b	    ;se asigna prioridad a la interrupción del grupo 1 bit0 (INT0)
    movlb   04H		    ;regreso al banco 4
    
inicio:
    bsf	    LATA, 0, b	    ;enciendo RA0
    call    retardo
    bcf	    LATA, 0, b	    ;apago RA0
    call    retardo
    goto    inicio
    
ISR_LP:
    bcf	    PIR1, 0, b	    ;bajo la bandera de INT0
    retfie
    
ISR_HP:
    btg	    LATD, 0, b	    ;alterno RD0
    bcf	    PIR1, 0, b	    ;bajo la bandera de INT0}
    retfie
 
retardo:
    movlb   5		; banco 5
    movlw   50
    movwf   var1, b	; b --> Banked BSR
    
xxx:
    movlw   50
    movwf   var2, b
    
yyy:
    movlw   5
    movwf   var3, b
    
zzz:
    decfsz var3, 1, 1	; 1 --> d (guardar en file) || 0 --> Acces Bank | 1 --> Banked BSR
    goto   zzz
    decfsz var2, 1, 1
    goto   yyy
    decfsz var1, 1, 1
    goto   zzz
    return
    
    end
