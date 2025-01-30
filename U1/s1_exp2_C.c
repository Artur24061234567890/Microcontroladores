#include<stdlib.h>
#include<stdio.h>
#include<pic18f57q43.h>
#include<xc.h>
#include"cabecera.h"

#define _XTAL_FREQ 4000000UL

void configuro();

void main()
{
    configuro();
    while(1)
    {
        while(PORTBbits.RB4 == 1);          //Espera activa a que B4 sea presionado
        while(PORTBbits.RB4 == 0);          //Espera activa a que B4 sea soltado
        LATFbits.LATF3 = ~LATFbits.LATF3;   //Cambio de estado del led
    }    
}

void configuro()
{
    OSCCON1 = 0x60;         //HFINTOSC
    OSCFRQ = 0x02;          //HFINTOSC a 4MHz
    OSCEN = 0x40;           //HFINTOSC enable
    
    ANSELFbits.ANSELF3 = 0; //RF3: ANALOG SELECTOR DESACTIVADO
    SLRCONFbits.SLRF3 = 1;  //RF3: SLEW RATE ACTIVADO
    INLVLFbits.INLVLF3 = 0; //RF3: TRABAJO SOLO CON TTL
    ODCONFbits.ODCF3 = 0;   //RF3: OPEN-DRAIN DESACTIVADO
    WPUFbits.WPUF3 = 0;     //RF3: WEAK PULL-UP DESACTIVADO
    TRISFbits.TRISF3 = 0;   //RF3: TRABAJA COMO OUTPUT
    //NO SE USA PORTF3 PORQUE ES UN OUTPUT
    LATFbits.LATF3 = 1;      //RF3: LATCHED 1 (BLOQUEADO EN 1) led interno apagado
    
    ANSELBbits.ANSELB4 = 0; //RB4: ANALOG SELECTOR DESACTIVADO
    SLRCONBbits.SLRB4 = 1;  //RB4: SLEW RATE ACTIVADO
    INLVLBbits.INLVLB4 = 1; //RB4: SCHMITT TRIGGER ACTIVADO
    ODCONBbits.ODCB4 = 0;   //RB4: OPEN-DRAIN DESACTIVADO
    WPUBbits.WPUB4 = 1;     //RB4: WEAK PULL-UP ACTIVADO
    TRISBbits.TRISB4 = 1;   //RB4: TRI-STATED(INPUT) ACTIVADO
    //EL PORTB4 SE PUEDE NOMBRAR DIRECTAMENTE EN EL MAIN
    //NO SE USA LATB PUES ES UN INPUT
}
