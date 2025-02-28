#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"

#define  _XTAL_FREQ 4000000UL

void configuro ();
void __interrupt (high_priority) ISR_HP();
void __interrupt (low_priority) IST_LP();

void main (void)
{
    configuro ();
    while (1)
    {
        LATAbits.LATA0 = 1;
        __delay_ms(125);
        LATAbits.LATA0 = 0;
        __delay_ms(125);               
    }
}

void  configuro()
{
    OSCCON1 = 0x60;
    OSCFRQ = 0x02;
    OSCEN = 0x40;
    TRISAbits.TRISA0 = 0;
    ANSELAbits.ANSELA0 = 0;
    LATAbits.LATA0 = 0; 
    TRISB = 0xFF;
    ANSELB = 0x00;
    TRISD = 0x00;
    ANSELD = 0x00;
    LATD = 0x00;
    WPUBbits.WPUB4 = 1;
    IPR1bits.INT0IP =1;
    INTCON0bits.IPEN = 1;
    INTCON0bits.GIEH = 1;
    INTCON0bits.GIEL = 1;
    INTCON0bits.INT0EDG = 0;
    PIE1bits.INT0IE = 1;
    INT0PPS = 0x0C;
}
void __interrupt(high_priority) ISR_HP()
{
    if (PIR1bits.INT0IF == 1)
    {
        for (int i=0; i<5;i++)
        {
            LATDbits.LATD0 = 1;
            __delay_ms(200);
            LATDbits.LATD0 = 0;
            __delay_ms(200);
        }
        PIR1bits.INT0IF = 0;
    }
}
void __interrupt (low_priority) ISR_LP()
{
    
}
