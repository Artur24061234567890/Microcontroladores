PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 16000000UL
	
    PSECT code, reloc=2, abs
    
    ORG    000000H
    goto    configuro

    ORG    000100H
    
configuro:
    ; oscilador
    movlb    00H	    ;banco 0(OSCON1 OSCFRQ OSCEN)
    movlw    01100000B   
    movwf    OSCCON1, b	    ;HFINTOSC y NDIV 1
    movlw    00000101B    
    movwf    OSCFRQ, b	    ;16MHz
    movlw    01000000B
    movwf    OSCEN, b	    ;Habilita el HFINTOSC
    ; GPIOS
    movlb    04H	    ;banco 4(GPIOS)
    ; RA1
    bcf	    TRISA, 1, b	    ;output
    bcf	    ANSELA, 1, b    ;digital
    bsf	    LATA, 1, b	    ;apagado
    ; timer
    movlb   03H		    ;banco 3(T0CON0 T0CON1 TMR0H TMR0L)
    movlw   10001001B
    movwf   T0CON0, b	    ;TMR0 enable, modo 8 bits, postscaler 1:10
    movlw   01111111B
    movwf   T0CON1, b	    ;CS: HFINTOSC, asincrono, prescaler 1:32768
    ;con esto conseguimos que cada ciclo de reloj dure 0.02048 segundos
inicio:
    ;1.4seg off
    movlb   03H		    ;banco 3(TMR0H)
    movlw   70		    ;70 x 0.02 = 1.4seg
    movwf   TMR0H, b	    ;cargamos 70 al TMR0
    movlb   04H
aaa:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    aaa
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATA, 1, b	    ;apago RA1
    ;0.7seg on
    movlb   03H		    ;banco 3(timers)
    movlw   35		    ;35 x 0.02 = 0.7seg
    movwf   TMR0H, b	    ;cargamos 35 al TMR0
    movlb   04H		    ;banco 4
bbb:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    bbb
    bcf	    PIR3, 7, b	    ;bajar bandera
    bcf	    LATA, 1, b	    ;enciendo RA1
    ;0.4seg off
    movlb   03H		    ;banco 3(TMR0H)
    movlw   20		    ;20 x 0.02 = 0.4seg
    movwf   TMR0H, b	    ;cargamos 20 al TMR0
    movlb   04H
ccc:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ccc
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATA, 1, b	    ;apago RA1
    ;0.2seg on
    movlb   03H		    ;banco 3(timers)
    movlw   10		    ;10 x 0.02 = 0.2seg
    movwf   TMR0H, b	    ;cargamos 10 al TMR0
    movlb   04H		    ;banco 4
ddd:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ddd
    bcf	    PIR3, 7, b	    ;bajar bandera
    bcf	    LATA, 1, b	    ;enciendo RA1
    ;0.6seg off
    movlb   03H		    ;banco 3(TMR0H)
    movlw   30		    ;30 x 0.02 = 0.6seg
    movwf   TMR0H, b	    ;cargamos 30 al TMR0
    movlb   04H
eee:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    eee
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATA, 1, b	    ;apago RA1
    ;1.9seg on
    movlb   03H		    ;banco 3(timers)
    movlw   95		    ;95 x 0.02 = 1.9seg
    movwf   TMR0H, b	    ;cargamos 95 al TMR0
    movlb   04H		    ;banco 4
fff:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    fff
    bcf	    PIR3, 7, b	    ;bajar bandera
    bcf	    LATA, 1, b	    ;enciendo RA1
    ;1.5seg off
    movlb   03H		    ;banco 3(TMR0H)
    movlw   75		    ;75 x 0.02 = 1.5seg
    movwf   TMR0H, b	    ;cargamos 75 al TMR0
    movlb   04H
ggg:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ggg
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATA, 1, b	    ;apago RA1
    ;1.3seg on
    movlb   03H		    ;banco 3(timers)
    movlw   65		    ;65 x 0.02 = 1.3seg
    movwf   TMR0H, b	    ;cargamos 65 al TMR0
    movlb   04H		    ;banco 4
hhh:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    hhh
    bcf	    PIR3, 7, b	    ;bajar bandera
    bcf	    LATA, 1, b	    ;enciendo RA1
    ;0.8seg off
    movlb   03H		    ;banco 3(TMR0H)
    movlw   40		    ;40 x 0.02 = 0.8seg
    movwf   TMR0H, b	    ;cargamos 40 al TMR0
    movlb   04H
iii:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    iii
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATA, 1, b	    ;apago RA1
    ;1.6seg on
    movlb   03H		    ;banco 3(timers)
    movlw   80		    ;80 x 0.02 = 1.6seg
    movwf   TMR0H, b	    ;cargamos 80 al TMR0
    movlb   04H		    ;banco 4
jjj:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    jjj
    bcf	    PIR3, 7, b	    ;bajar bandera
    bcf	    LATA, 1, b	    ;enciendo RA1
    goto    inicio

    end
