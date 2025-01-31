    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "CABECERA.inc"

    PSECT CODE, reloc=2, abs ;abs es absolute 

    var1	equ	500H ;equ es equivalent
    var2	equ	501H
    var3	equ	503H	
	
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
    bcf	    TRISF, 3, b	; RF3 salida y 			b --> Banked BSR
    bcf	    ANSELF, 3, b; RF3 digital y 		b --> Banked BSR
    bsf	    LATF, 3, b	; RF3 inicia en 1 lógico	b --> Banked BSR

inicio:
    call    retardo
    movlb   4		; banco 4
    btg	    LATF, 3, b	
    goto    inicio
    
retardo:
    movlb   5		; banco 5
    movlw   100
    movwf   var1, b	; b --> Banked BSR
    
xxx:
    movlw   250
    movwf   var2, b
    
yyy:
    movlw   5
    movwf   var3, b
    
zzz:
    decfsz var3, 1, 1	; 1 --> d (guardar en file) || 0 --> Acces Bank | 1 --> Banked BSR
    goto   zzz
    decfsz var2, 1, 1
    goto   yyy
    decfsz var1, 1, 1
    goto   zzz
    return
    
    end
