; Program: Semaforo con pulsador
; Description: Simulacion de un semaforo peatonal con pulsador
; Author: Andrés Manuel Armesto Fernández
; Created: 15/07/2024 (dd/MM/yyyy)

#include <avr/io.h>

.org 0x00
rjmp setup

setup:
  .global main

main:
  ldi r16, 0b00111111    ; Configura PB0, PB1, PB2 (pin digital 8, 9, 10) como salidas
  out DDRB, r16
  ldi r16, 0b00001100    ; Configura PD2, PD3 (pin digital 2, 3) como salidas
  out DDRD, r16

  ; Configuración de interrupción para el pulsador en el pin 6 (PD6/PCINT22)
  ldi r16, (1 << PCIE2)  ; Habilita interrupciones de cambio lógico para PCINT[23:16]
  sts PCICR, r16
  ldi r16, (1 << PCINT22) ; Habilita la máscara de interrupción para PCINT22 (PD6)
  sts PCMSK2, r16

  sei                   ; Habilita interrupciones globales

loop:
  rcall sem_red_off
  rcall sem_yellow_off
  rcall sem_green_off
  rcall pea_red_off
  rcall pea_green_off

  rcall sem_red_on
  rcall pea_green_on
  rcall delay_1s
  rcall pea_green_blink

  rcall sem_red_off
  rcall pea_green_off
  rcall pea_red_on
  rcall sem_green_on
  rcall delay_3s

  rcall sem_green_off
  rcall pea_red_off

  rcall pea_green_on
  rcall sem_yellow_blink

  rjmp loop

sem_red_on:
  sbi _SFR_IO_ADDR(PORTB), 2  ; Establece PB2 (enciende el LED rojo en el pin 10)
  ret

sem_yellow_on:
  sbi _SFR_IO_ADDR(PORTB), 1  ; Establece PB1 (enciende el LED amarillo en el pin 9)
  ret

sem_green_on:
  sbi _SFR_IO_ADDR(PORTB), 0  ; Establece PB0 (enciende el LED en el pin 8)
  ret

sem_red_off:
  cbi _SFR_IO_ADDR(PORTB), 2  ; Limpia PB2 (apaga el LED rojo en el pin 10)
  ret

sem_yellow_off:
  cbi _SFR_IO_ADDR(PORTB), 1  ; Limpia PB1 (apaga el LED amarillo en el pin 9)
  ret

sem_green_off:
  cbi _SFR_IO_ADDR(PORTB), 0  ; Limpia PB0 (apaga el LED en el pin 8)
  ret

pea_red_on:
  sbi _SFR_IO_ADDR(PORTD), 3  ; Establece PD3 (enciende el LED rojo del peatón en el pin 3)
  ret

pea_green_on:
  sbi _SFR_IO_ADDR(PORTD), 2  ; Establece PD2 (enciende el LED verde del peatón en el pin 2)
  ret

pea_red_off:
  cbi _SFR_IO_ADDR(PORTD), 3  ; Limpia PD3 (apaga el LED rojo del peatón en el pin 3)
  ret

pea_green_off:
  cbi _SFR_IO_ADDR(PORTD), 2  ; Limpia PD2 (apaga el LED verde del peatón en el pin 2)
  ret

; Realiza el parpadeo del LED amarillo para los coches
sem_yellow_blink:
  rcall sem_yellow_on
  rcall delay_1s
  rcall sem_yellow_off
  rcall delay_1s
  rcall sem_yellow_on
  rcall delay_1s
  rcall sem_yellow_off
  rcall delay_1s
  rcall sem_yellow_on
  rcall delay_1s
  rcall sem_yellow_off
  ret

; Realiza el parpadeo del LED verde para los peatones
pea_green_blink:
  rcall pea_green_on
  rcall delay_1s
  rcall pea_green_off
  rcall delay_1s
  rcall pea_green_on
  rcall delay_1s
  rcall pea_green_off
  rcall delay_1s
  rcall pea_green_on
  rcall delay_1s
  rcall pea_green_off
  rcall delay_1s
  ret

delay_1s:
    ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    ret

delay_3s:
    ldi  r18, 122
    ldi  r19, 193
    ldi  r20, 130
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    ret
