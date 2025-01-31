    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    PSECT CODE, reloc=2, abs ;abs es absolute 

    ORG 000000H ;ORG es origin, que indica la dirección de memoria
    goto configuro
    
    ORG 000020H ;debemos movernos a la DM 20 para no chocarnos con la 8 y 18

configuro:
    movlb   00H		    ; banco 0
    movlw   60H		
    movwf   OSCCON1, b	    ; b --> Banked BSR  a --> Acces Bank
    movlw   02H		    ; 02H --> 4MHz	    05H --> 16MHz
    movwf   OSCFRQ, b
    movlw   40H
    movwf   OSCEN, b
    movlb   04H		    ; banco 4
    
    bcf	    TRISF, 3, b	    ; RF3 salida 	b --> Banked BSR
    bcf	    ANSELF, 3, b    ; RF3 digital 	b --> Banked BSR
    bsf	    LATF, 3, b	    ; RF3 inicia en 1	b --> Banked BSR
    
    bsf	    TRISA, 3, b	    ; RA3 entrada 	b --> Banked BSR
    bcf	    ANSELA, 3, b    ; RA3 digital 	b --> Banked BSR
    bsf	    WPUA, 3, b	    ; RA3 pull-up activado
    
    bsf	    TRISA, 4, b	    ; RA4 entrada	b --> Banked BSR
    bcf	    ANSELA, 4, b    ; RA4 digital	b --> Banked BSR
    bsf	    WPUA, 4, b	    ; RA4 pull-up activado
			
start:
    btfsc   PORTA, 3        ; si RA3 está presionado registra un 0 (skip)
    goto    led_on          ; si RA3 no está presionado el led se enciande

    btfsc   PORTA, 4        ; si RA4 está presionado registra un 0 (skip)
    goto    led_on          ; si RA4 no está presionado, enciende el LED

    bsf     LATF, 3         ; el led se apaga si se producen ambos skips
    goto    start           

led_on:
    bcf     LATF, 3         ; led encendido (lógica negada)
    goto    start           
    end
