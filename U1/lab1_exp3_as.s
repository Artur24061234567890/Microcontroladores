    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL

    PSECT code, reloc=2, abs

    val1    equ 0x0C       ; 00001100B
    val2    equ 0x0A       ; 00001010B
    val3    equ 0x08       ; 00001000B
    
    ORG    000000H
    goto    configuro


    ORG    000020H
configuro:
    
    movlb    00H    
    movlw    60H    
    movwf    OSCCON1, b
    movlw    02H    
    movwf    OSCFRQ, b
    movlw    40H    
    movwf    OSCEN, b

    
    movlb    04H    
    bcf	     TRISD, 0, b    ;RD0 como output
    bcf      ANSELD, 0, b   ;RD0 como digital
    bcf	     LATD, 0, b	    ;RD0 en 0
      
    setf     TRISB, b	    ;RB como inputs
    clrf     ANSELB, b	    ;RB en digitales 

inicio:
    movf    PORTB, w       ; Cargar el estado de PORTB en WREG
    cpfseq  val1           ; Comparar con 00001100B (0x0C)
    goto    check2         ; Si no es igual, revisar la siguiente
    bsf     LATD, 0        ; Si es igual, encender la bomba
    goto    inicio

check2:
    cpfseq  val2           ; Comparar con 00001010B (0x0A)
    goto    check3         ; Si no es igual, revisar la siguiente
    bsf     LATD, 0        ; Si es igual, encender la bomba
    goto    incio

check3:
    cpfseq  val3           ; Comparar con 00001000B (0x08)
    goto    apagar         ; Si no es igual a ninguna, apagar la bomba
    bsf     LATD, 0        ; Si es igual, encender la bomba
    goto    inicio

apagar:
    bcf     LATD, 0        ; Apagar la bomba
    goto    inicio
