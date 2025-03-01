/*
 8 caracteres dibujados en la pantalla LCD
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

unsigned char corazon[] = {0x0A,0x15,0x11,0x0A,0x04,0x00,0x00,0x00};  
unsigned char campana[] = {0x04,0x0E,0x0E,0x0E,0x1F,0x00,0x04,0x00};
unsigned char robot[]   = {0x1F,0x15,0x1F,0x1F,0x0E,0x0A,0x1B,0x00};
unsigned char check[]   = {0x01,0x03,0x16,0x1C,0x08,0x00,0x00,0x00};
unsigned char speaker[] = {0x01,0x03,0x0F,0x0F,0x0F,0x03,0x01,0x00};
unsigned char music[]   = {0x01,0x03,0x05,0x09,0x09,0x0B,0x1B,0x18};
unsigned char skull[]   = {0x0E,0x15,0x1B,0x0E,0x0E,0x00,0x00,0x00};
unsigned char candado[] = {0x0E,0x11,0x11,0x1F,0x1B,0x1B,0x1F,0x00};

void configuro();      //Declaro configuro()
void LCD_init();     //

void main (void)
{
    configuro();
    LCD_init();
    GENERACARACTER(corazon,0); //Guarda corazon en la posición 0
    GENERACARACTER(campana,1);
    GENERACARACTER(robot,2);
    GENERACARACTER(check,3);
    GENERACARACTER(speaker,4);
    GENERACARACTER(music,5);
    GENERACARACTER(skull,6);
    GENERACARACTER(candado,7);
    while(1)
    {
        POS_CURSOR(2, 0);
        ENVIA_CHAR(0x00);  // Muestra lo almacenado en posición 0
        POS_CURSOR(2, 2);
        ENVIA_CHAR(0x01);
        POS_CURSOR(2, 4);
        ENVIA_CHAR(0x02);
        POS_CURSOR(2, 6);
        ENVIA_CHAR(0x03);
        POS_CURSOR(2, 8);
        ENVIA_CHAR(0x04);
        POS_CURSOR(2, 10);
        ENVIA_CHAR(0x05);
        POS_CURSOR(2, 12);
        ENVIA_CHAR(0x06);
        POS_CURSOR(2, 14);
        ENVIA_CHAR(0x07);
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
