    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    PSECT CODE, reloc=2, abs ;abs es absolute 

    ORG 000000H ;ORG es origin, que indica la dirección de memoria
    goto configuro
    
    ORG 000020H ;debemos movernos a la DM 20 para no chocarnos con la 8 y 18

configuro:
    movlb   00H		; banco 0
    movlw   60H		
    movwf   OSCCON1, b	; b --> Banked BSR  a --> Acces Bank
    movlw   02H		; 02H --> 4MHz	    05H --> 16MHz
    movwf   OSCFRQ, b
    movlw   40H
    movwf   OSCEN, b
    movlb   04H		; banco 4
    bcf	    TRISF, 3, b	; RF3 salida y b --> Banked BSR
    bcf	    ANSELF, 3, b; RF3 digital y b --> Banked BSR
    bsf	    LATF, 3, b	; b --> Banked BSR
    bsf	    TRISB, 4, b	; RD0 entrada y b --> Banked BSR
    bcf	    ANSELB, 4, b; RD0 digital y b --> Banked BSR
    bsf	    WPUB, 4, 1
			;entradas no se definen con LAT

wile1:
    btfss   PORTB,4
    goto    wile1
wile2: 
    btfsc   PORTB,4
    goto    wile2
    btg	    LATF,3
    goto wile1
    end

