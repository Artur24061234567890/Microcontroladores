/*
 Código para utilizar la pantalla LCD 2x16, en este código se escribitá UPC y el ciclo.
 * Las respectivas librerías de LCD deben ser cargadas en el Header como en el Source
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"            //Libreria para el LCD

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro ();      //Declaro configuro()
void LCD_init();        //Lo usaremos para limpiar la pantalla al inicio

void main(void)
{
    configuro();
    LCD_init();
    POS_CURSOR(1,6);
    ESCRIBE_MENSAJE("UPC",3);
    POS_CURSOR(2,5);
    ESCRIBE_MENSAJE("2025-0",6);
    while(1)
    {
    
    }
}

void configuro() //Defino configuro()
{
    //OSCILADOR
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x02;     //HFINTOSC a 4MHz
    OSCEN   = 0x40;     //HFINTOSC enable
    //Puerto RD
    TRISD = 0x00;           //OUTPUT
    ANSELD = 0x00;          //DIGITAL
    LATD = 0x00;            //INICIA APAGADO
}

void LCD_init()
{
    __delay_ms(29);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}
