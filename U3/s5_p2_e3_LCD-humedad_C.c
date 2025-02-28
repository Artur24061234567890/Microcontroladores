/*
 Código para que el LCD muestre el valor de la humedad previamente definida
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"            //Libreria para el LCD

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

int humedad = 65;
unsigned int decena = 0;
unsigned int unidad = 0;

void configuro ();      //Declaro configuro()
void LCD_init();        //Lo usaremos para limpiar la pantalla al inicio
void convierte(unsigned int numero);

void main(void)
{
    configuro();
    LCD_init();
    while(1)
    {
        convierte(humedad);
        POS_CURSOR(1,5);
        ESCRIBE_MENSAJE("HUM: ",5);
        ENVIA_CHAR(decena + 48);
        ENVIA_CHAR(unidad + 48);
        POS_CURSOR(1,12);
        ESCRIBE_MENSAJE("%1",1);
        __delay_ms(1000);
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

void convierte(unsigned int numero)
{
    decena = numero/10;
    unidad = numero%10;
}
