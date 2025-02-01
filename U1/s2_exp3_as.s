PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"
    
    #define __XTAL_FREQ 4000000UL
    
	var1    equ	    500H
	var2    equ	    501H
	var3    equ	    502H
    
    PSECT code, reloc=2, abs
 
    valor   equ	    00H		

    ORG	    000000H
    goto    configuro	    
    
    ORG	    000020H
    
configuro:
    movlb   00H		; banco 0 SIRVE PARA ESTAR EN EL BANCO 0
    movlw   60H
    movwf   OSCCON1, b  ;b--> banked BSR  a--> Access bank
    movlw   02H		;02H---> 4Mhz   05H---> 16Mhz
    movwf   OSCFRQ, b	
    movlw   40H
    movwf   OSCEN,  b
    movlb   04H		;BANCO4
    bsf	    TRISB, 4,b
    bcf	    ANSELB,4,b
    bsf	    WPUB,4,B
    movlw   00000000B
    movwf   TRISD,b
    clrf    ANSELD, b
    movlw   3FH
    movwf   LATD,b
    movlb   05H
    clrf    valor, b ; RF3 digital y b banked bsr
    movlb   04H

inicio:
    btfsc   PORTB,4
    goto    inicio
    btfss   PORTB,4 
    goto    $-1
 
cuenta_up:
    movlb   05H
    incf    valor,f,b
    movlw   10
    cpfseq  valor
    goto    sigue
    clrf    valor,b 
sigue:
    movf    valor,w,b
    addwf   valor,w,b
    call    tabla  
    movwf   LATD,b
    MOVLB   04H
    call    retardo
    goto    cuenta_up
tabla:
    movlb   04H
    addwf   PCL,f,b
    retlw   3FH;0
    retlw   06H;1
    retlw   5BH;2
    retlw   4FH;3
    retlw   66H;4
    retlw   6DH;5
    retlw   7DH;6
    retlw   07H;7
    retlw   7FH;8
    retlw   67H;9
    retlw   00H
    retlw   00H
    retlw   00H
    retlw   00H
    retlw   00H
    retlw   00H
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
