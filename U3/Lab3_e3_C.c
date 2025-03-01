#include <stdlib.h>
#include <stdio.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 16000000UL  

unsigned char dutycycle = 0;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro ();
void convierte(unsigned char numero);
void __interrupt(irq(IRQ_INT0)) INT0_ISR(void);
void __interrupt(irq(IRQ_INT2)) INT2_ISR(void);

void main()
{
    configuro();
    LCD_INIT();
    POS_CURSOR(1,2);
    ESCRIBE_MENSAJE2("MODULO PWM");
    while(1)
    {
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE2("Duty Cycle: ");
        convierte(dutycycle);
        ENVIA_CHAR(centena+48);
        ENVIA_CHAR(decena+48);
        ENVIA_CHAR(unidad+48);
        ENVIA_CHAR('%');
        CCPR1H=dutycycle/2;
    }
}

void configuro ()
{
    OSCCON1 = 0x60;
    OSCFRQ = 0x05;
    OSCEN = 0x40;
    TRISD = 0x00;
    ANSELD = 0x00;
    TRISBbits.TRISB0=1;
    ANSELBbits.ANSELB0=0;
    WPUBbits.WPUB0=1;
    TRISBbits.TRISB2=1;
    ANSELBbits.ANSELB2=0;
    WPUBbits.WPUB2 = 1;
    PIE1bits.INT0IE = 1;
    PIE10bits.INT2IE=1;
    INTCON0bits.INT0EDG=0;
    INTCON0bits.INT2EDG=0;
    PIR1bits.INT0IF=0;
    PIR10bits.INT2IF=0;
    INTCON0bits.GIE=1;
    TRISCbits.TRISC2=0;
    ANSELCbits.ANSELC2=0;
    T2PR=49;
    RC2PPS=0x15;
    CCP1CON=0x9C;
    CCPR1H=25;
    CCPR1L=0;
    T2CLKCON=0x01;
    T2CON = 0xC0;
}

void convierte(unsigned char numero)
{
    centena=numero/100;
    decena=(numero%100)/10;
    unidad=numero%10;
}

void __interrupt(irq(IRQ_INT0)) INT0_ISR(void)
{
    if(dutycycle == 100)
    {
        dutycycle=100;
    }
    else
    {
        dutycycle=dutycycle+10;
    }
    PIR1bits.INT0IF=0;
}

void __interrupt(irq(IRQ_INT2)) INT2_ISR(void)
{
    if(dutycycle ==0)
    {
        dutycycle = 0;
    }
    else
    {
        dutycycle=dutycycle-10;
    }
    PIR10bits.INT2IF=0;
}
