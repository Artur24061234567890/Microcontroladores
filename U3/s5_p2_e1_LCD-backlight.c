/*
 Código para encender el backlight del LCD mientras se mantenga pulsando RB1
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
    POS_CURSOR(1,4);
    ESCRIBE_MENSAJE("Backligh",8);
    while(1)
    {
        if(PORTBbits.RB1==0)    //Al presionar el botón RB1:
        {
            POS_CURSOR(2,6);
            ESCRIBE_MENSAJE("ON ",3);
            LATBbits.LATB0 = 1; //Backlight encendido
        }
        else
        {
            LATBbits.LATB0 = 0; //Backligth apagado
            POS_CURSOR(2,6);
            ESCRIBE_MENSAJE("OFF",3);
        }
    }
}

void configuro() //Defino configuro()
{
    //OSCILADOR
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x02;     //HFINTOSC a 4MHz
    OSCEN   = 0x40;     //HFINTOSC enable
    //Puerto RB0
    TRISBbits.TRISB0 = 0;   //OUTPUT
    ANSELBbits.ANSELB0 = 0; //DIGITAL
    //Puerto RB1
    TRISBbits.TRISB1 = 1;   //INPUT
    ANSELBbits.ANSELB1 = 0; //DIGITAL
    WPUBbits.WPUB1 = 1;     //Pull-Up activado
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
