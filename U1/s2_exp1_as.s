PROCESSOR 18F57Q43
#include  "cabecera.inc"
#include <pic18f57q43.inc>
#define _XTAL_FREQ 4000000UL
    var1    equ	    00H
    var2    equ	    01H
    var3    equ	    02H
    
PSECT code ,reloc=2, abs

ORG	000000H
goto	configuro
 
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
    movlw   00000000B
    movwf   TRISD,b
    clrf    ANSELD,b
    clrf    LATD,b

inicio:
    movlw   00111110B
    movwf   LATD,b
    movlb   05H
    call    retardo
    movlb   04H
    movlw   01110011B
    movwf   LATD,b
    movlb   05H
    call    retardo
    movlb   04H
    movlw   00111001B
    movwf   LATD,b
    movlb   05H
    call    retardo
    movlb   04H
    goto    inicio
    
retardo:
    movlw   100
    movwf   var1,b
xxx:
    movlw   250
    movwf   var2,b
yyy:
    movlw   5
    movwf   var3,b
zzz:
    decfsz  var3,1,1
    goto    zzz
    decfsz  var2,1,1
    goto    yyy
    decfsz  var1,1,1
    goto    zzz
    return
    
    end
