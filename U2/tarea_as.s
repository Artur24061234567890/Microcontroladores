    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL
	
    PSECT code, reloc=2, abs
    
    ORG	    000000H
    goto    configuro

    ORG	    000020H
    
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
    ; RA4 T0CKIPPS
    bsf	    TRISA, 1, b	    ;input
    bcf	    ANSELA, 1, b    ;digital
    bcf	    WPUA, 1, b	    ;pull-up
    ;bsf	    INLVLA, 4, b    ;SM
    ; RD5
    bcf	    TRISD, 5, b	    ;RD5 output
    bcf	    ANSELD, 5, b    ;RD5 digital
    bsf	    LATD, 5, b	    ;RD5 apagado
    ;porsiacaso regreso el pps T0CKIPPS al RA4 
    movlb   02H
    movlw   00000001B
    movwf   T0CKIPPS, b	    ;cargo RA0 en binario 00001100
    movlb   04H
    ; timer
    movlb   03H		    ;banco 3(T0CON0 T0CON1 TMR0H TMR0L)
    movlw   80H
    movwf   T0CON0, b	    ;TMR0 enable, modo 8 bits, postscaler 1:1
    movlw   00010000B
    movwf   T0CON1, b	    ;CS: T0CKIPPS, asincrono, prescaler 1:1 (00010000 = 10)
    movlw   2
    movwf   TMR0H, b	    ;carga 5 para que sea comparado con la cuenta de TMR0
inicio:
    movlb   04H		    ;banco 4 (PIR LATx)
    btfss   PIR3, 7, 1	    ;bandera del TMR0	    1 = b solo que los comodines deben ser o todos letras o todos números
    goto    inicio
    bcf	    PIR3, 7, 1	    ;bajo la bandera del TMR0
    btg	    LATD, 5, 1	    ;alterno RD5
    goto    inicio
    end
