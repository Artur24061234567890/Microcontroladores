#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include <string.h>

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

uint8_t contador = 0;

void configuro();
void transmitir (uint8_t conta);

void main()
{
    configuro();
    while(1)
    {
        transmitir(contador);
        __delay_ms(1000);
        contador = contador + 1;
        if(contador == 10)
        {
            contador = 0;
        }
    }
}
void configuro()
{
    OSCCON1 = 0x60;
    OSCFRQ  = 0x02;
    OSCEN   = 0x40;
    U1BRGH  = 0x00;
    U1BRGL  = 25;
    U1CON0  = 0x30;
    U1CON1  = 0x80;
    U1CON2  = 0x00;
    RF0PPS  = 0x20;
    
}
void transmitir (uint8_t conta)
{
    U1TXB = conta + 48;
    while(U1ERRIRbits.TXMTIF == 0);
}
