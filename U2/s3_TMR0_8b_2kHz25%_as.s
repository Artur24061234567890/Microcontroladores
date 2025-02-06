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
    movwf   T0CON1,b	    ;CS: HFINTOSC, sincrono, prescaler 1:8

inicio:
    movlb   03H		    ;banco 3(TMR0H)
    movlw   62
    movwf   TMR0H, b	    ;cargamos 62 al TMR0
    movlb   04H
    
xxx:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    xxx
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATD, 5, b	    ;activo RD5
    
    movlb   03H		    ;banco 3(timers)
    movlw   187
    movwf   TMR0H, b	    ;cargamos 187 al TMR0
    movlb   04H		    ;banco 4
yyy:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    yyy
    bcf	    PIR3, 7, b	    ;bajar bandera
    bcf	    LATD, 5, b	    ;apago RD5
    goto    inicio
    
    end
