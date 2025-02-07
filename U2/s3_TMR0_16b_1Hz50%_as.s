    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL ;4MHz es 4 con 6ceros
	
    PSECT code, reloc=2, abs
    
    ORG    000000H
    goto    configuro

    ORG    000020H
    
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
    ; RD5
    bcf	    TRISD, 5, b	    ;salida
    bcf	    ANSELD, 5, b    ;digital
    bcf	    LATD, 5, b	    ;apagado
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
    movwf   TMR0L, b	    ;cargamos DB al byte menos significativo (L)
    movlb   04H		    ;regresamos al banco 4
    
inicio:
    btfsc   PIR3, 7, b	    ;pausa activa hasta que PIR3 bit 7(TMR0IF) sea 1 (bandera)
    goto    inicio
    bcf	    PIR3, 7, b	    ;bajo la bandera (necesario)
    btg	    LATD, 5, b	    ;alterno RD5
    goto    cargar

    end
