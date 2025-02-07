/*
    Algoritmo que permite generar una onda cuadrada de frecuencia de 1Hz
    con un DC de 50% a travez del puerto RD5, con un oscilador de 4MHz
    y el timer0 configurado a 16bits
*/
    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL ;4MHz es 4 con 6ceros
	
    PSECT code, reloc=2, abs
    
    ORG    000000H
    goto    configuro

    ORG    000100H
    
configuro:
    ; oscilador
    movlb    00H	    ;banco 0(OSCON1 OSCFRQ OSCEN)
    movlw    60H    
    movwf    OSCCON1, b	    ;HFINTOSC y NDIV 1
    movlw    02H    
    movwf    OSCFRQ, b	    ;4MHz
    movlw    40H    
    movwf    OSCEN, b	    ;Habilita el HFINTOSC
    ; GPIOS
    movlb    04H	    ;banco 4(GPIOS)
    ; RB4
    bsf	    TRISB, 4, b	    ;RB4 input
    bcf	    ANSELB, 4, b    ;RB4 digital
    bsf	    WPUB, 4, b	    ;RB4 pull-up activado
    ; timer
    movlb   03H		    ;banco 3(T0CON0 T0CON1 TMR0H TMR0L)
    movlw   90H
    movwf   T0CON0, b	    ;TMR0 enable, modo 16 bits, postscaler 1:1
    movlw   65H
    movwf   T0CON1, b	    ;CS: HFINTOSC, sincrono, prescaler 1:32

cargar:
    movlb   03H		    ;banco 3(registros de timer)
    movlw   0x0BH
    movwf   TMR0H, b	    ;cargamos 0B al byte más significativo (H)
    movlw   0xDCH	    
    movwf   TMR0L	    ;cargamos DB al byte menos significativo (L)
    movlb   04H		    ;regresamos al banco 4
    
inicio:
    btfsc   PIR3, 7, b	    ;pausa activa hasta que PIR3 bit 7(TMR0IF) sea 1 (bandera)
    goto    inicio
    bcf	    PIR3, 7, b	    ;bajo la bandera (necesario)
    btg	    LATD, 5, b	    ;alterno RD5
    goto    cargar
    
    end
