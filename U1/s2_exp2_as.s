PROCESSOR 18F57Q43

#include <xc.inc>
#include <pic18f57q43>
#include "cabecera.inc"
    
PSECT	code, reloc=2, abs
	
valor	equ	00H

ORG	000000H
goto	cofiguro
	
ORG	000020H
configuro:
    movlb   00H
    movlw   60H
    movwf   OSCCON1,b
    movlw   02H
    movwf   OSCFRQ,b
    movlw   40H
    movwf   OSCEN,b
    movlb   04H
    bsf	    TRISB,4,b
    bcf	    ANSELB,4,b
    bsf	    WPUB,4,b
    movlw   00000000B
    movwf   TRISD,b
    clrf    ANSELD,b
    movlw   3FH
    movwf   LATD,b
    movlb   05H
    clrf    valor,b
    movlb   04H
inicio:
    btfsc   PORTB,4
    goto    inicio
    btfss   PORTB,4
    goto    $-1
    movlb   05H
    incf    valor,f,b
    movlw   10
    cpfseq  valor
    goto    sigue
    clrf    valor,b
sigue:
    movf    valor,w
    addwf   valor,w,b
    call    tabla
    movwf   LATD,b
    goto    inicio
tabla:
    movlb   04H
    addwf   PCL,f,b
    retlw   3FH
    retlw   06H
    retlw   5BH
    retlw   4FH
    retlw   66H
    retlw   6DH
    retlw   7DH
    retlw   07H
    retlw   7FH
    retlw   67H
    retlw   00H
    retlw   00H
    retlw   00H
    retlw   00H
    retlw   00H
    retlw   00H

    end    
