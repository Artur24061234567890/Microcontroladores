/*
 Código para utilizar el teclado 4x4 en conjunto con el LCD, con la limitante 
 * de que solo se podrá reconocer y escribir los caracteres especificados
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"            //Libreria para el LCD
#include "teclado.h"        //Libreria para el telcado 4x4

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro ();      //Declaro configuro()
void LCD_init();        //Lo usaremos para limpiar la pantalla al inicio

void main(void)
{
    configuro();
    teclado_init();
    LCD_init();
    POS_CURSOR(1,6);
    ESCRIBE_MENSAJE("UPC",3);
    char tecla = 0;
    while(1)
    {
        tecla = teclado_getc();
        if(tecla != 0)
        {
            if(tecla == '3')
            {
                POS_CURSOR(2,5);
                ESCRIBE_MENSAJE("3",1);
            }
        }
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
    //Puerto RB
    TRISB = 0xF0;           //<RB7-RB4>INPUT <RB3-RB0>OUTPUT
    WPUB = 0xF0;            //<RB7-RB4>WPUon <RB3-RB0>WPUoff
    ANSELB = 0x00;          //DIGITAL
}

void LCD_init()
{
    __delay_ms(29);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}
