/*
 Mostrar en LCD el nombre y apellido de un usuario registrado
 tras ingresar su DNI mediante un teclado 4x4. Fosc16MHz
*/

#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"            // Librería para el LCD
#include "teclado.h"        // Librería para el teclado 4x4

#define _XTAL_FREQ 16000000UL // Fosc a 16MHz
#define MAX_DIGITOS 8        // Número de caracteres del DNI

void configuro();
void LCD_init();

char dni_registrado[MAX_DIGITOS] = {'7', '1', '4', '2', '8', '1', '4', '8'}; // DNI registrado
char ingreso[MAX_DIGITOS]; // Buffer de ingreso
int indice = 0; // Posición de la entrada

void main(void)
{
    configuro();
    teclado_init();
    LCD_init();
    
    POS_CURSOR(1,1);
    ESCRIBE_MENSAJE("Ingrese DNI:", 12);
    
    char tecla;
    while(1)
    {
        tecla = teclado_getc();
        if(tecla != 0) // Si se presiona una tecla
        {
            if(tecla >= '0' && tecla <= '9' && indice < MAX_DIGITOS) // Solo números
            {
                ingreso[indice] = tecla;
                POS_CURSOR(2, indice + 4); // Mover cursor
                ESCRIBE_MENSAJE("*", 1); // Mostrar '*'
                indice++;
            }
            else if(tecla == '#') // Verificar DNI
            {
                int es_correcto = 1; // Asumimos que es correcto
                
                if(indice == MAX_DIGITOS) // Solo si se ingresaron 8 dígitos
                {
                    for(int i = 0; i < MAX_DIGITOS; i++)
                    {
                        if(ingreso[i] != dni_registrado[i])
                        {
                            es_correcto = 0; // Si un carácter es diferente, es incorrecto
                            break;
                        }
                    }
                }
                else
                {
                    es_correcto = 0; // Si no se ingresaron 8 caracteres, es incorrecto
                }

                BORRAR_LCD();
                if(es_correcto)
                {
                    POS_CURSOR(1,1);
                    ESCRIBE_MENSAJE("David Atencio", 13);
                    __delay_ms(5000); // Mostrar por 5 segundos
                }
                else
                {
                    POS_CURSOR(1,0);
                    ESCRIBE_MENSAJE("Usuario Invalido", 16);
                    __delay_ms(3000); // Mostrar por 3 segundos
                }
                
                BORRAR_LCD();
                POS_CURSOR(1,1);
                ESCRIBE_MENSAJE("Ingrese DNI:", 12);
                indice = 0; // Reiniciar ingreso
            }
            else if(tecla == '*') // Borrar última entrada
            {
                if(indice > 0)
                {
                    indice--;
                    POS_CURSOR(2, indice + 4);
                    ESCRIBE_MENSAJE(" ", 1); // Borrar con espacio
                }
            }
        }
    }
}


void configuro() //Defino configuro()
{
    //OSCILADOR
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x05;     //HFINTOSC a 16MHz
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
