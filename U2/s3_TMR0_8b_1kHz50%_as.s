    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL
	
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
    ; RD5
    bcf	    TRISD, 5, b	    ;RD5 output
    bcf	    ANSELD, 5, b    ;RD5 digital
    bcf	    LATD, 5, b	    ;RD5 apagado
    ; timer
    movlb   03H		    ;banco 3(T0CON0 T0CON1 TMR0H TMR0L)
    movlw   80H
    movwf   T0CON0, b	    ;TMR0 enable, modo 8 bits, postscaler 1:1
    movlw   63H
    movwf   T0CON1, b	    ;CS: HFINTOSC, sincrono, prescaler 1:8
    movlw   250
    movwf   TMR0H, b	    ;carga 250 para que sea comparado con la cuenta de TMR0
inicio:
    movlb   04H		    ;banco 4 (PIR LATx)
    btfss   PIR3, 7, 1	    ;bandera del TMR0	    1 = b solo que los comodines deben ser o todos letras o todos números
    goto    inicio
    bcf	    PIR3, 7, 1	    ;bajo la bandera del TMR0
    btg	    LATD, 5, 1	    ;alterno RD5
    goto    inicio
    end
