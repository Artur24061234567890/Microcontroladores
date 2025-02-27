/*
 Código para utilizar el teclado 4x4, se tienen que añadir al proyecto los dos
 * archivos del teclado, teclado.h en los HeaderFiles y teclado.c en los SourceFiles
 * además de incluir "teclado.h" en el maincode
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "teclado.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro ();      //Declaro configuro()

void main(void)
{
    configuro();
    char tecla = 0;     //El valor 0 en un caracter 00 = NULL (carácter nulo)
    while(1)
    {
        tecla = teclado_getc(); //Función de la librería para detectar la tecla presionada
        if(tecla != 0)          //Si se detecta algo diferente de nulo (tecla presionada)
        {
            if(tecla == '3')
            {
                LATDbits.LATD0 = ~LATDbits.LATD0;
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
    //Teclado
    teclado_init();         //Función de la librería necesaria
}
