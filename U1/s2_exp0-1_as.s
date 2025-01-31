    PROCESSOR 18F57Q43
    #include <xc.inc>
    #include <pic18f57q43.inc>
    #include "cabecera.inc"

    PSECT CODE, reloc=2, abs ;abs es absolute 

    var1	equ	500H ;equ es equivalent
    var2	equ	501H
    var3	equ	503H	
 
    ORG 000500H ;ORG es origin, que indica la dirección de memoria de programa
    numero:	db  0x04H,  0xAFH,  0xBEH,  0x89H 
    ; va asigando los valores al espacio 501=04, 502=AF y así
    ORG 000000H ;Regresamos a la dirección de memoria de programa 000000H
    goto configuro
    
    ORG 000020H ;Nos movemos a la dirección ROM 000020H para no interferir en otras
    
configuro:
    movlb   00H		    ; Nos movemos al banco 0
    movlw   60H		
    movwf   OSCCON1, b	    ; b --> Banked BSR  a --> Acces Bank
    movlw   02H		    ; 02H --> 4MHz	    05H --> 16MHz
    movwf   OSCFRQ, b
    movlw   40H
    movwf   OSCEN, b
    
    movlb   04H		    ; banco 4
    clrf    TRISD, b	    ; RD como salidas
    clrf    ANSELD, b	    ; RD como digitales
    clrf    LATD, b	    ; RD bloqueadas en 0
    
inicio:
    movlw   0x00H	    ;
    movwf   TBLPTRU, b	    ; carga 00H al byte alto del puntero de tabla
    movlw   0x05H	    ;
    movwf   TBLPTRH, b	    ; carga 05H al byte medio del puntero de tabla
    movlw   0x00H	    ;
    movwf   TBLPTRL, b	    ; carga 00H al byte bajo del puntero de tabla
; Ya tenemos la dirección apuntada 000500H donde se encuentra la tabla "numero"
    TBLRD*		    ;
    movf    TABLAT, w, b    ;
    movwf   LATD, b	    ;
    call    retardo
    incf    TBLPTRL, f, b   ;
    TBLRD*		    ;
    movf    TABLAT, w, b    ;
    movwf   LATD, b	    ;
    call    retardo
    incf    TBLPTRL, f, b   ;
    TBLRD*		    ;
    movf    TABLAT, w, b    ;
    movwf   LATD, b	    ;
    call    retardo
    incf    TBLPTRL, f, b   ;
    TBLRD*		    ;
    movf    TABLAT,w,b	    ;
    movwf   LATD,b	    ;
    call    retardo
    
    goto    inicio	    ;
    
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
    movlb   04H
    return
    
    end    
