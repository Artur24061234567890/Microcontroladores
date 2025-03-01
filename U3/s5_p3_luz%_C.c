/* 
 * Ejemplo: Uso del A/D con LDR
 Se usa un LDR como voltaje variable que se mide continuamente por el ADC
 * mostrando el porcenjate en la pantalla LCD
 Circuitería: LDR pin RA1, LCD pines D. se puede simular el LDR con un POT
*/

#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro ();      //Declaro configuro()
void LCD_init();
void captura_ADC();
int convierte(float luz);
int valor = 0;
int LDR = 0;
char TT[20];

void main(void)
{
    configuro();
    LCD_INIT();
    while(1)
    {
        captura_ADC();
        valor = ADRESH;
        LDR = convierte(valor);
        POS_CURSOR(1,2);
        sprintf(TT,"LUZ = %d",LDR);
        ESCRIBE_MENSAJE(TT,8);
        ENVIA_CHAR('%');
        __delay_ms(500);
    }
}

void configuro() //Defino configuro()
{
    //OSCILADOR
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x02;     //HFINTOSC a 4MHz
    OSCEN   = 0x40;     //HFINTOSC enable
    //RA1
    TRISAbits.TRISA1    = 1;
    ANSELAbits.ANSELA1  = 1;
    //Puerto RD
    TRISD = 0x00;           //OUTPUT
    ANSELD = 0x00;          //DIGITAL
    //ADC
    ADCON0bits.ADON     = 1;    //ADC: 1
    ADCON0bits.ADFM     = 0;    //Justificado izquierda
    ADCON0bits.CS       = 1;    //ADCRC, no se usa ADCLK
    ADPCH = 0x01;               //Positive Channel RA0
    ADCON2 = 0x62;              //CRS = 6, modo promediador
    ADRPT = 64;                 //Repetirá las mismas veces por las que se divide
}

void LCD_init()
{
    __delay_ms(29);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void captura_ADC()
{
    ADCON0bits.GO = 1;
    while(ADCON0bits.GO);
}

int convierte(float luz)
{
    int porcentaje = 0;
    porcentaje = (luz/250)*100;
    return porcentaje;
}
