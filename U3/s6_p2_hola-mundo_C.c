#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include <string.h>

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro (void);
void UART1_Data_Send(unsigned char dato);
void UART1_String_Send(const char *cadena);

void main(void)
{
    configuro();
    while(1){
        UART1_String_Send("Hola mundo");
        UART1_String_Send("\n\r");
        __delay_ms(1000);
    }
}

void configuro (void)
{
    OSCCON1 = 0x60;
    OSCFRQ = 0x02;
    OSCEN = 0x40;
    U1BRGH = 0x00;
    U1BRGL = 25;
    U1CON0 = 0x20;
    RF0PPS = 0x20;
    U1CON1 = 0x80;
    U1CON2 = 0x00;
}

void UART1_Data_Send(unsigned char dato)
{
    U1TXB = dato;
    while(U1ERRIRbits.TXMTIF == 0);
}
void UART1_String_Send(const char *cadena)
{
    unsigned char tam;
    unsigned char i = 0;
    tam = strlen(cadena);
    for (i = 0; i<tam;i++)
    {
        U1TXB = cadena[i];
        while(U1ERRIRbits.TXMTIF == 0);
    }
}
