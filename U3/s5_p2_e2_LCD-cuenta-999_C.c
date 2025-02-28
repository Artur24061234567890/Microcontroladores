/*
 Código para que el LCD muestre una cuenta repitente hasta 999
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"            //Libreria para el LCD

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

unsigned int cuenta = 0;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro ();      //Declaro configuro()
void LCD_init();        //Lo usaremos para limpiar la pantalla al inicio
void convierte(int numero);

void main(void)
{
    configuro();
    LCD_init();
    POS_CURSOR(1,6);
    ESCRIBE_MENSAJE("UPC",3);
    while(1)
    {
        POS_CURSOR(2,3);
        ESCRIBE_MENSAJE("cuenta: ",8);
        convierte(cuenta);
        ENVIA_CHAR(centena +48);        //48 es 0 en ASCII
        ENVIA_CHAR(decena +48);
        ENVIA_CHAR(unidad +48);
        if(cuenta == 999)
        {
            cuenta = 0;
        }
        else
        {
            cuenta++;
        }
        __delay_ms(100);
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

void convierte(int numero)
{
    centena = numero/100;
    decena = (numero%100)/10;
    unidad = numero%10;
}
