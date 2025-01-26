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
        LATAbits.LATA0 = ~LATAbits.LATA0;
        __delay_ms(200);
    }
}

void configuro()
{
    OSCCON1 = 0x60;         //HFINTOSC
    OSCFRQ = 0x02;          //HFINTOSC a 4MHz
    OSCEN = 0x40;           //HFINTOSC enable
    TRISAbits.TRISA0 = 0;   //RA0: salida
    ANSELAbits.ANSELA0 = 0; //RA0: digital
    LATAbits.LATA0 = 0;     //RA0: inicia apagado
}
