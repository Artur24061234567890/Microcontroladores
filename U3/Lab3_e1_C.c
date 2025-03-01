/* 
 * Monitoreo de calidad del agua en granjas de camarón
 * Se usan 4 potenciómetros para simular sensores de Temperatura, Oxígeno Disuelto, PH y Salinidad
 * Se muestra la información en una pantalla LCD 2x16
 * Se generan alertas si los valores salen de los rangos óptimos
 */

#include <stdio.h>
#include <stdlib.h>
#include <pic18f57q43.h>
#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 4000000UL    //Fosc a 4MHz

void configuro();      // Configuración de los periféricos
void LCD_init();
void captura_ADC();
int convierte(float voltaje, float minV, float maxV, float minVal, float maxVal);
void evaluarParametros();

int temp, oxigeno, salinidad, ph;
char mensaje[20];

void main(void) {
    configuro();
    LCD_init();
    
    while(1) {
        captura_ADC();
        
        POS_CURSOR(1,0);
        sprintf(mensaje, "T:%d O:%d S:%d P:%d", temp, oxigeno, salinidad, ph);
        ESCRIBE_MENSAJE(mensaje, 16);
        
        evaluarParametros();
        __delay_ms(1000);
    }
}

void configuro() {
    OSCCON1 = 0x60;
    OSCFRQ  = 0x02;
    OSCEN   = 0x40;
    
    TRISA = 0x0F;  // RA0, RA1, RA2, RA3 como entrada
    ANSELA = 0x0F; // Habilitar entradas analógicas
    
    TRISD = 0x00;
    ANSELD = 0x00;
    
    ADCON0bits.ADON = 1;
    ADCON0bits.ADFM = 0;
    ADCON0bits.CS   = 1;
    ADCON2 = 0x62;
    ADRPT = 64;
}

void LCD_init() {
    __delay_ms(29);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void captura_ADC() {
    // Leer Temperatura
    ADPCH = 0x00; 
    ADCON0bits.GO = 1;
    while(ADCON0bits.GO);
    temp = convierte(ADRESH, 0.5, 4.7, 10, 42);
    
    // Leer Oxígeno Disuelto
    ADPCH = 0x01; 
    ADCON0bits.GO = 1;
    while(ADCON0bits.GO);
    oxigeno = convierte(ADRESH, 0.5, 4.7, 0.5, 9.5);
    
    // Leer Salinidad
    ADPCH = 0x02; 
    ADCON0bits.GO = 1;
    while(ADCON0bits.GO);
    salinidad = convierte(ADRESH, 0.5, 4.7, 5, 56);
    
    // Leer PH
    ADPCH = 0x03; 
    ADCON0bits.GO = 1;
    while(ADCON0bits.GO);
    ph = convierte(ADRESH, 0.5, 4.7, 3.5, 9.7);
}

int convierte(float voltaje, float minV, float maxV, float minVal, float maxVal) {
    return (int)((voltaje - minV) * (maxVal - minVal) / (maxV - minV) + minVal);
}

void evaluarParametros() {
    POS_CURSOR(2,0);
    if (temp < 23 || temp > 31) {
        ESCRIBE_MENSAJE("Alerta temp     ", 16);
    } else if (oxigeno < 5 || oxigeno > 7) {
        ESCRIBE_MENSAJE("Alerta oxigeno  ", 18);
    } else if (salinidad < 15 || salinidad > 25) {
        ESCRIBE_MENSAJE("Alerta salinidad", 18);
    } else if (ph < 6.5 || ph > 8.5) {
        ESCRIBE_MENSAJE("Alerta pH       ", 18);
    } else {
        ESCRIBE_MENSAJE("Parametros OK     ", 18);
    }
}
