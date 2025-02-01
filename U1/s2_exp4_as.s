    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL



    var1    equ    00H    
    var2    equ    01H
    

    PSECT code, reloc=2, abs


    ORG    000300H   
		; H    O    L    A
    mensaje1:    db  76H, 3FH, 38H, 77H

    
    ORG    000400H    

		; U    P    C
    mensaje2:    db  00H, 3EH, 73H, 39H


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
    bsf	     TRISA, 0, b   
    bcf      ANSELA, 0, b   
    movlw    00000000B    
    movwf    TRISD, b
    clrf     ANSELD, b    
    movlw    0xF0H
    movwf    TRISB, b   
    clrf     LATD, b      


inicio:
    
    btfsc    PORTA, 0
    goto     msg_hola    
    goto     msg_upc     


msg_hola:
  
    clrf     TBLPTRU, b
    movlw    0x03H
    movwf    TBLPTRH, b
    clrf     TBLPTRL, b
    goto     multiplex


msg_upc:
  
    clrf     TBLPTRU, b
    movlw    0x04H
    movwf    TBLPTRH, b
    clrf     TBLPTRL, b
    goto     multiplex


multiplex:
    TBLRD*+
    movff    TABLAT, LATD
    bsf      LATB, 3, b
    movlb    05H
    call     retardo
    movlb    04H
    bcf	     LATB,3,b
    TBLRD*+
    movff    TABLAT, LATD
    bsf      LATB, 2, b
    movlb    05H
    call     retardo
    movlb    04H
    bcf      LATB, 2, b
    TBLRD*+
    movff    TABLAT, LATD
    bsf      LATB, 1, b
    movlb    05H
    call     retardo
    movlb    04H
    bcf      LATB, 1, b
    TBLRD*+
    movff    TABLAT, LATD
    bsf      LATB, 0, b
    movlb    05H
    call     retardo
    movlb    04H
    bcf      LATB, 0, b
    goto     inicio

retardo:
    movlw    3
    movwf    var1, b 
xxx:
    movlw    110
    movwf    var2, b
yyy:
    decfsz   var2,1,1
    goto     yyy
    decfsz   var1, 1,1
    goto     xxx
    return
    end
