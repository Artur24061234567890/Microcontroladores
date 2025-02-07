/*
    Algoritmo que genere 2 ondas cuadradas 1kHz y 2kHz ambas con DC50%
    según el estado de un pulsador RB4 1 = 1kHz, 0 = 2kHz
    usa el timer0 en modo 8 bits y un oscilador de 4MHz
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
    ; RD5
    bcf	    TRISD, 5, b	    ;RD5 output
    bcf	    ANSELD, 5, b    ;RD5 digital
    bcf	    LATD, 5, b	    ;RD5 apagado
    ; RB4
    bsf	    TRISB, 4, b	    ;RB4 input
    bcf	    ANSELB, 4, b    ;RB4 digital
    bsf	    WPUB, 4, b	    ;RB4 pull-up activado
    
    ; timer
    movlb   03H		    ;banco 3(T0CON0 T0CON1 TMR0H TMR0L)
    movlw   80H
    movwf   T0CON0, b	    ;TMR0 enable, modo 8 bits, postscaler 1:1
    movlw   63H
    movwf   T0CON1, b	    ;CS: HFINTOSC, sincrono, prescaler 1:8

inicio:
    movlb   04H		    ;banco 4
    btfsc   PORTB, 4, b	    ;RB4 recibe 1 lógico si no se presiona
    goto    freq_1k
    goto    freq_2k
    
freq_1k:   
    movlb   03H
    movlw   250
    movwf   TMR0H, b	    ;carga 250 a TMR0H para compararlo con TMR0L
    movlb   04H		    ;regresar al banco original (buena práctica)
xxx:
    btfss   PIR3, 7, b	    ;pausa activa hasta que PIR3 bit 7(TMR0IF) sea 1 (bandera)
    goto    xxx
    bcf	    PIR3, 7, b	    ;bajo la bandera (necesario)
    btg	    LATD, 5, b	    ;alterno RD5
    movlb   04H		    ;aparentemente innecesario :)
    goto    inicio
    
freq_2k:   
    movlb   03H
    movlw   125
    movwf   TMR0H, b	    ;carga 250 a TMR0H para compararlo con TMR0L
    movlb   04H		    ;regresar al banco original (buena práctica)
yyy:
    btfss   PIR3, 7, b	    ;pausa activa hasta que PIR3 bit 7(TMR0IF) sea 1 (bandera)
    goto    yyy
    bcf	    PIR3, 7, b	    ;bajo la bandera (necesario)
    btg	    LATD, 5, b	    ;alterno RD5
    movlb   04H		    ;aparentemente innecesario :)
    goto    inicio
    
    end
