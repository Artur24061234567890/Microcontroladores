/*
 Utilizar el teclado 4x4 en conjunto con el LCD para ingresar una clave
 * predefinida y corroborar si es correcta o no
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"            //Libreria para el LCD
#include "teclado.h"        //Libreria para el telcado 4x4

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz
#define MAX_DIGITOS 4           // Número de caracteres de la contraseña

void configuro();
void LCD_init();

char password[MAX_DIGITOS] = {'3', '3', '6', '9'}; // Contraseña predefinida
char ingreso[MAX_DIGITOS]; // Buffer de ingreso
int indice = 0; // Posición de la entrada

void main(void)
{
    configuro();
    teclado_init();
    LCD_init();
    
    POS_CURSOR(1,1);
    ESCRIBE_MENSAJE("Ingrese clave:", 14);
    
    char tecla;
    while(1)
    {
        tecla = teclado_getc();
        if(tecla != 0) // Si se presiona una tecla
        {
            if(tecla >= '0' && tecla <= '9' && indice < MAX_DIGITOS) // Solo números
            {
                ingreso[indice] = tecla;
                POS_CURSOR(2, indice + 5); // Mover cursor
                ESCRIBE_MENSAJE("*", 1); // Mostrar '*'
                indice++;
            }
            else if(tecla == '#') // Verificar contraseña
            {
                int es_correcta = 1; // Asumimos que es correcta
                
                if(indice == MAX_DIGITOS) // Solo si se ingresaron 4 dígitos
                {
                    for(int i = 0; i < MAX_DIGITOS; i++)
                    {
                        if(ingreso[i] != password[i])
                        {
                            es_correcta = 0; // Si un carácter es diferente, es incorrecta
                            break;
                        }
                    }
                }
                else
                {
                    es_correcta = 0; // Si no se ingresaron 4 caracteres, es incorrecto
                }

                BORRAR_LCD();
                if(es_correcta)
                {
                    POS_CURSOR(1,4);
                    ESCRIBE_MENSAJE("Correcto", 8);
                }
                else
                {
                    POS_CURSOR(1,3);
                    ESCRIBE_MENSAJE("Incorrecto", 10);
                }
                
                __delay_ms(2000); // Esperar 2 segundos
                BORRAR_LCD();
                POS_CURSOR(1,1);
                ESCRIBE_MENSAJE("Ingrese clave:", 14);
                indice = 0; // Reiniciar ingreso
            }
            else if(tecla == '*') // Borrar última entrada
            {
                if(indice > 0)
                {
                    indice--;
                    POS_CURSOR(2, indice + 5);
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
