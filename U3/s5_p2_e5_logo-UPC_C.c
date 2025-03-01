/*
 * Ejercicio 5
 Código para dibujar en la pantalla LCD
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

unsigned char logo1[]={0x00,0x01,0x02,0x06,0x0C,0x18,0x10,0x10};
unsigned char logo2[]={0x04,0x08,0x08,0x18,0x1C,0x1E,0x1F,0x1F};
unsigned char logo3[]={0x00,0x10,0x08,0x0C,0x06,0x03,0x01,0x01};
unsigned char logo4[]={0x10,0x18,0x1C,0x0E,0x07,0x03,0x01,0x00};
unsigned char logo5[]={0x0F,0x07,0x03,0x02,0x02,0x04,0x1F,0x0E};
unsigned char logo6[]={0x01,0x03,0x07,0x0E,0x1C,0x18,0x10,0x00};

void configuro();      //Declaro configuro()
void LCD_init();     //

void main (void)
{
    configuro();
    LCD_init();
    GENERACARACTER(logo1,0);
    GENERACARACTER(logo2,1);
    GENERACARACTER(logo3,2);
    GENERACARACTER(logo4,3);
    GENERACARACTER(logo5,4);
    GENERACARACTER(logo6,5);
    while(1)
    {
        POS_CURSOR(1,0);
        ENVIA_CHAR(0x00);
        ENVIA_CHAR(0x01);
        ENVIA_CHAR(0x02);
        ESCRIBE_MENSAJE("EXIGETE",7);
        POS_CURSOR(2,0);
        ENVIA_CHAR(0x03);
        ENVIA_CHAR(0x04);
        ENVIA_CHAR(0x05);
        ESCRIBE_MENSAJE("INNOVA",6);
    }
}

void configuro() //Defino configuro()
{
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x02;     //HFINTOSC a 4MHz
    OSCEN   = 0x40;     //HFINTOSC enable
    //Puerto RD
    TRISD = 0x00;           //OUTPUT
    ANSELD = 0x00;          //DIGITAL
}

void LCD_init()
{
    __delay_ms(29);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}
