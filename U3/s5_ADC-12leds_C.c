/*
El código utiliza el conversor ADC y representa el valor medido en RA0 a los
 * puertos RD y RB mediante 12 leds
*/
#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro ();      //Declaro configuro()
void captura_ADC();     //Declaro la captura_ADC()

void main (void)
{
    configuro();
    while(1)
    {
        captura_ADC();
        LATD = ADRESH;  //Solo adigno los bits más significativos al LATD
        LATB = ADRESL;  //A LATB se le asignan los 4 bits restantes
        __delay_ms(100);
    }
}

void configuro() //Defino configuro()
{
    OSCCON1 = 0x60;     //HFINTOSC
    OSCFRQ  = 0x02;     //HFINTOSC a 4MHz
    OSCEN   = 0x40;     //HFINTOSC enable
    //Puerto RA0
    TRISAbits.TRISA0 = 1;   //INPUT
    ANSELAbits.ANSELA0 = 1; //ANALÓGICO
    //Puerto RD
    TRISD = 0x00;           //OUTPUT
    ANSELD = 0x00;          //DIGITAL
    //Puerto RB
    TRISB = 0x00;           //OUTPUT
    ANSELB = 0x00;          //DIGITAL
    //Módulo ADC
    ADCON0bits.ADON = 1;    //ADC ON
    ADCON0bits.ADCONT = 0;  //Acción única
    ADCON0bits.CS = 1;      //Usa ADCRC, mediciones esporádicas
    ADCON0bits.ADFM = 0 ;   //Justificado izquierda, mayor cantidad de bits en ADRESH
    ADCON2bits.PSIS = 0;    //Último valor como referencia
    ADCON2bits.ACLR = 0;    //No se realiza limpieza del ADCC
    ADCON2bits.MD = 010;    //Modo: Promedio
    ADCON2bits.CRS = 110;   //Valor:6, se dividirá la suma entre 2^6
    ADRPT = 64;             //Se tomarán 64 muestras y se acumularán en ADCC
    ADPCH = 0x00;           //Positive CHannel: RA0
}

void captura_ADC() //Defino captura_ADC()
{
    ADCON0bits.GO = 1;          //Inicia la conversión
    while(ADCON0bits.GO == 1);  //Cuando la conversión termine el bit GO será 0
}
