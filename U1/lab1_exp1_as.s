    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    #define _XTAL_FREQ 4000000UL

    var1	equ	500H ;equ es equivalent
    var2	equ	501H
    var3	equ	503H	
    valor	equ	504H
	
    PSECT code, reloc=2, abs

    
    
    ORG    000000H
    goto    configuro


    ORG    000100H
configuro:
    
    movlb    00H    
    movlw    60H    
    movwf    OSCCON1, b
    movlw    02H    
    movwf    OSCFRQ, b
    movlw    40H    
    movwf    OSCEN, b

    
    movlb    04H    
    clrf    TRISD, b	    ;RD como output
    clrf    ANSELD, b	    ;RD como digital
    clrf    LATD, b	    ;RD en 0
    
    clrf    TRISC, b	    ;RC como output
    clrf    ANSELC, b	    ;RC como digital
    clrf    LATC, b	    ;RC en 0
    
    bsf    TRISA, 0, b	    ;RA0 como input
    bcf    ANSELA, 0, b	    ;RA0 en digitale
    
    bsf    TRISA, 1, b	    ;RA1 como input
    bcf    ANSELA, 1, b	    ;RA1 en digitale
    
    clrf    valor,b	    ;limpio valor

inicio:
    movlb   04H
    btfss   PORTA,0,b	    ;leo A0, si está presionado salta
    goto    inicio
    btfsc   PORTA,0,b	    ;leo A0, si lo suelto salta
    goto    $-1
    
    movlb   05H
    incf    valor,f,b	    ;incremento en uno valor
    btfss   PORTA,1,b	    ;si no presiono A1 vuelvo a leer A0, si presiono A1 salto
    goto    inicio
    
    movf    valor,w,b	    ;copio el número de valor al Wreg
    addwf   valor,w,b	    ;lo multiplico por 2 y guardo en Wreg
    clrf    valor,b	    ;limpio valor
    call    texto	    
    goto    inicio	    ;una vez terminado vuelvo a comenzar
    
texto:
    movlb   04H
    addwf   PCL,f,b	    ;sumo el Wreg al PCL para desplazarme entre cuentas
    nop
    goto    cuenta1
    goto    cuenta2
    goto    cuenta3
    goto    cuenta4
    goto    cuenta5
    goto    cuenta6
    
cuenta1:
    movlb   04H
    movlw   0x76    ;letra H
    movwf   LATD,b
    call    retardo
    movlw   0x5c    ;letra O
    movwf   LATD,b
    call    retardo
    movlw   0x38    ;letra L
    movwf   LATD,b
    call    retardo
    movlw   0x77    ;letra A
    movwf   LATD,b
    call    retardo
    movlw   0x00    ;letra 
    movwf   LATD,b
    call    retardo
    movlw   0x3e    ;letra U
    movwf   LATD,b
    call    retardo
    movlw   0x73    ;letra P
    movwf   LATD,b
    call    retardo
    movlw   0x39   ;letra C
    movwf   LATD,b
    call    retardo
    
    movlb   05H
    incf    valor,f,b	    ;completada la frase valor sube 1
    movf    valor,w,b	    ;mueve ese valor a Wreg
    addwf   valor,w,b	    ;lo duplica y lo guarda en Wreg
    call    tabla	    
    movlb   05H
    movlw   5
    cpfseq  valor,b
    goto    cuenta1	;cambiar cuenta
    clrf    valor,b
    bra	    inicio
  
  cuenta2:
    movlb   04H
    movlw   0x3f    ;letra 0
    movwf   LATD,b
    call    retardo
    movlw   0x06	    ;letra 1
    movwf   LATD,b
    call    retardo
    movlw   0x5b   ;letra 2
    movwf   LATD,b
    call    retardo
    movlw   0x4f   ;letra 3
    movwf   LATD,b
    call    retardo
    movlw   0x66    ;letra 4
    movwf   LATD,b
    call    retardo
    movlw   0x6d    ;letra 5
    movwf   LATD,b
    call    retardo
    movlw   0x7d    ;letra 6
    movwf   LATD,b
    call    retardo
    movlw   0x07  ;letra 7
    movwf   LATD,b
    call    retardo
    movlw   0x7f  ;letra 8
    movwf   LATD,b
    call    retardo
    movlw   0x6f   ;letra 9
    movwf   LATD,b
    call    retardo
    
    movlb   05H
    incf    valor,f,b
    movf    valor,w,b
    addwf   valor,w,b
    call    tabla
    movlb   05H
    movlw   5
    cpfseq  valor,b
    goto    cuenta2	;cambiar cuenta
    clrf    valor,b
    bra    inicio
  
  cuenta3:
    movlb   04H
    movlw   0x3f    ;letra 0
    movwf   LATD,b
    call    retardo
    movlw   0x5b	    ;letra 2
    movwf   LATD,b
    call    retardo
    movlw   0x66   ;letra 4
    movwf   LATD,b
    call    retardo
    movlw   0x7d   ;letra 6
    movwf   LATD,b
    call    retardo
    movlw   0x7f    ;letra 8
    movwf   LATD,b
    call    retardo
   
    movlb   05H
    incf    valor,f,b
    movf    valor,w,b
    addwf   valor,w,b
    call    tabla
    movlb   05H
    movlw   5
    cpfseq  valor,b
    goto    cuenta3	;cambiar cuenta
    clrf    valor,b
    movlb   04H
    bra     inicio
  
  cuenta4:
    movlb   04H
    movlw   0x06	    ;letra 1
    movwf   LATD,b
    call    retardo
    movlw   0x4f   ;letra 3
    movwf   LATD,b
    call    retardo
    movlw   0x6d    ;letra 5
    movwf   LATD,b
    call    retardo
    movlw   0x07  ;letra 7
    movwf   LATD,b
    call    retardo
    movlw   0x6f   ;letra 9
    movwf   LATD,b
    call    retardo
    
    movlb   05H
    incf    valor,f,b
    movf    valor,w,b
    addwf   valor,w,b
    call    tabla
    movlb   05H
    movlw   5
    cpfseq  valor,b
    goto    cuenta4	;cambiar cuenta
    clrf    valor,b
    bra    inicio
  
  cuenta5:
    movlb   04H
    movlw   0x76    ;letra H
    movwf   LATD,b
    call    retardo
    movlw   0x5c	    ;letra O
    movwf   LATD,b
    call    retardo
    movlw   0x38    ;letra L
    movwf   LATD,b
    call    retardo
    movlw   0x77    ;letra A
    movwf   LATD,b
    call    retardo
    movlw   0x00    ;letra 
    movwf   LATD,b
    call    retardo
    movlw   0x3e    ;letra U
    movwf   LATD,b
    call    retardo
    movlw   0x73    ;letra P
    movwf   LATD,b
    call    retardo
    movlw   0x39   ;letra C
    movwf   LATD,b
    call    retardo
    movlw   0x06   ;letra I
    movwf   LATD,b
    call    retardo
    movlw   0x54   ;letra N
    movwf   LATD,b
    call    retardo
    movlw   0x5c   ;letra O
    movwf   LATD,b
    call    retardo
    
    movlb   05H
    incf    valor,f,b
    movf    valor,w,b
    addwf   valor,w,b
    call    tabla
    movlb   05H
    movlw   5
    cpfseq  valor,b
    goto    cuenta5	;cambiar cuenta
    clrf    valor,b
    bra     inicio

  cuenta6:
    movlb   04H
    movlw   0x77    ;letra A
    movwf   LATD,b
    call    retardo
    movlw   0x7c	    ;letra B
    movwf   LATD,b
    call    retardo
    movlw   0x39    ;letra C
    movwf   LATD,b
    call    retardo
    movlw   0x5e    ;letra D
    movwf   LATD,b
    call    retardo
    movlw   0x79   ;letra E
    movwf   LATD,b
    call    retardo
    movlw   0x71    ;letra F
    movwf   LATD,b
    call    retardo
    
    movlb   05H
    incf    valor,f,b
    movf    valor,w,b
    addwf   valor,w,b
    call    tabla
    movlb   05H
    movlw   5
    cpfseq  valor,b
    goto    cuenta6	;cambiar cuenta
    clrf    valor,b
    bra	    inicio
    
tabla:
    movlb   04H
    addwf   PCL,f,b
    retlw   000
    retlw   001
    retlw   010
    retlw   011
    retlw   100
    retlw   101
    
    
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
