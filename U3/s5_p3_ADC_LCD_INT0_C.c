/* 
Módulo ADC con LCD y con interrupciones
Circuitería: dos resistencias variables en RA1 y RA2, un led en RA0, y el pulsador INT0 en RB0(pull up interno)
*/

#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro ();      //Declaro configuro()
unsigned int captura_ADC2(unsigned char canal);
void convierte(unsigned int numero);
void __interrupt(irq(IRQ_INT0)) INT0_ISR(void); //Lo usaremos para limpiar la pantalla al inicio

unsigned char dec_mil = 0;
unsigned char uni_mil = 0;
unsigned char centena = 0;
unsigned char decena  = 0;
unsigned char unidad  = 0;

void main(void)
{
    configuro();
    LCD_INIT();
    POS_CURSOR(1,6);
    ESCRIBE_MENSAJE2("UPC");        //Esta es la versión 2, ya no requiere poner la cantidad de caracteres
    POS_CURSOR(2,5);
    ESCRIBE_MENSAJE2("2024-0");
    while(1)
    {
        LATAbits.LATA0=1;
        __delay_ms(200);
        LATAbits.LATA0=0;
        __delay_ms(200);
    }
}

void configuro() //Defino configuro()
{
    //OSCILADOR
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x02;     //HFINTOSC a 4MHz
    OSCEN   = 0x40;     //HFINTOSC enable
    //RA0
    TRISAbits.TRISA0    = 0;
    ANSELAbits.ANSELA0  = 0;
    //RA1
    TRISAbits.TRISA1    = 1;
    ANSELAbits.ANSELA1  = 1;
    //RA2
    TRISAbits.TRISA2    = 1;
    ANSELAbits.ANSELA2  = 1;
    TRISBbits.TRISB0    = 1;
    ANSELBbits.ANSELB0  = 0;
    WPUBbits.WPUB0      = 1;
    INTCON0bits.GIE     = 1;
    INTCON0bits.INT0EDG = 0;
    PIE1bits.INT0IE     = 1;//Puerto RD
    TRISD = 0x00;           //OUTPUT
    ANSELD = 0x00;          //DIGITAL
    ADCON0bits.FM       =1;
    ADCON0bits.CS       =1;
    ADCON0bits.ADON     =1;//INICIA APAGADO
}

unsigned int captura_ADC2(unsigned char canal)
{
    ADPCH = canal;
    ADCON0bits.GO = 1;
    while(ADCON0bits.GO);
    return  ((ADRESH << 8)+ ADRESL);   
}

void convierte(unsigned int numero)
{
    dec_mil =   numero/10000;
    uni_mil =  (numero%10000)/1000;
    centena =  (numero%1000)/100;
    decena  =  (numero%100)/10;
    unidad  =   numero%10;
}

void __interrupt(irq(IRQ_INT0)) INT0_ISR(void)
{
    BORRAR_LCD();
    convierte(captura_ADC2(1));
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE2("AN1:");
    ENVIA_CHAR(uni_mil + 48);
    ENVIA_CHAR(centena + 48);
    ENVIA_CHAR(decena + 48);
    ENVIA_CHAR(unidad + 48);
    convierte(captura_ADC2(2));
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE2("AN2:");
    ENVIA_CHAR(uni_mil + 48);
    ENVIA_CHAR(centena + 48);
    ENVIA_CHAR(decena + 48);
    ENVIA_CHAR(unidad + 48);
    PIR1bits.INT0IF = 0;
}
