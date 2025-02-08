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
    ; RB0
    bcf	    TRISB, 0, b	    ;output
    bcf	    ANSELB, 0, b    ;digital
    bsf	    LATB, 0, b	    ;encendido
    ; RB1
    bcf	    TRISB, 1, b	    ;output
    bcf	    ANSELB, 1, b    ;digital
    bsf	    LATB, 1, b	    ;encendido
    ; RB2
    bcf	    TRISB, 2, b	    ;output
    bcf	    ANSELB, 2, b    ;digital
    bsf	    LATB, 2, b	    ;encendido
    ; RB3
    bcf	    TRISB, 3, b	    ;output
    bcf	    ANSELB, 3, b    ;digital
    bsf	    LATB, 3, b	    ;encendido
    ; timer
    movlb   03H		    ;banco 3(T0CON0 T0CON1 TMR0H TMR0L)
    movlw   10001001B
    movwf   T0CON0, b	    ;TMR0 enable, modo 8 bits, postscaler 1:10
    movlw   01101001B
    movwf   T0CON1, b	    ;CS: HFINTOSC, sincrono, prescaler 1:1024
    ;con esto conseguimos que cada ciclo de reloj dure 0.00064 segundos
inicio:
    ;0.00064seg 1
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
aaa:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    aaa
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;enciendo RB0
    bsf	    LATB, 1, b	    ;enciendo RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 2
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
bbb:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    bbb
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apago RB0
    bsf	    LATB, 1, b	    ;enciendo RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 3
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
ccc:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ccc
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;encendido RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 4
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
ddd:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ddd
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apagado RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 5
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
eee:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    eee
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;encendido RB0
    bsf	    LATB, 1, b	    ;encendido RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 6
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
fff:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    fff
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apagado RB0
    bsf	    LATB, 1, b	    ;encendido RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 7
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
ggg:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ggg
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;encendido RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bsf	    LATB, 3, b	    ;enciendo RB3
    ;0.00064seg 8
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
hhh:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    hhh
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apagado RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bsf	    LATB, 3, b	    ;encendido RB3
    ;0.00064seg 1
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
iii:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    iii
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;enciendo RB0
    bsf	    LATB, 1, b	    ;enciendo RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 2
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
jjj:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    jjj
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apago RB0
    bsf	    LATB, 1, b	    ;enciendo RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 3
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
kkk:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    kkk
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;encendido RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 4
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
lll:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    lll
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apagado RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bsf	    LATB, 2, b	    ;enciendo RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 5
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
mmm:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    mmm
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;encendido RB0
    bsf	    LATB, 1, b	    ;encendido RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 6
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
nnn:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    nnn
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apagado RB0
    bsf	    LATB, 1, b	    ;encendido RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 7
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
ooo:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ooo
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bsf	    LATB, 0, b	    ;encendido RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    ;0.00064seg 8
    movlb   03H		    ;banco 3(TMR0H)
    movlw   1		    ;solo un ciclo reloj
    movwf   TMR0H, b	    ;cargamos 1 al TMR0
    movlb   04H
ppp:
    btfss   PIR3, 7, b	    ;activación de bandera
    goto    ppp
    bcf	    PIR3, 7, b	    ;bajar la bandera 
    bcf	    LATB, 0, b	    ;apagado RB0
    bcf	    LATB, 1, b	    ;apagado RB1
    bcf	    LATB, 2, b	    ;apagado RB2
    bcf	    LATB, 3, b	    ;apagado RB3
    goto inicio
    
    end
