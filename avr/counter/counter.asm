/*
 *  counter.asm
 *
 *  Created: 15.03.2014 21:07:25
 *  Author: Paradigmn
 *  Pushbutton on INT0/1
 *  Digits on PB0-7, multiplexed with PD0/1&4/5
 *  ATTiny 2313 @8MHz
 *
 *  r16=temp,r19-22=digit1-4
 */
 ;___________________________________________

 .include "2313def.inc"

 .org 0000							;Interupt vectors
 rjmp start
 rjmp inte0
 rjmp inte1
 reti
 reti
 reti
 reti
 reti
 reti
 reti
 reti

 ;_______________ Intitial __________________

 start:
 ldi r16,low(ramend)
 out spl,r16							;Set stackpointer
 ldi r16,255
 out ddrb,r16							;PB0-7 output
 ldi r16,0b11110011
 out ddrd,r16							;PD0/1&4/5 output,INT0/1 input
 in r16,mcucr
 ldi r16,(1<<isc01)|(1<<isc11)
 out mcucr,r16							;INT0/1 to falling edge
 in  r16,gimsk
 ldi r16,(1<<int0)|(1<<int1)
 out gimsk,r16							;INT0/1 activation
 ldi r19,0
 ldi r20,0
 ldi r21,0
 ldi r22,0							;Counter initialization
 sei

 ;_________________ Digits __________________

 digit1:
 ldi zh,high (2*numbers)
 ldi zl,low  (2*numbers)					;Load Z-pointer
 mov r16,r19
 add r16,r19
 add zl,r16
 lpm
 ldi r16,0b11100011
 out portd,r16
 out portb,r0							;Display digit1
 rcall shift

 digit2:
 ldi zh,high (2*numbers)
 ldi zl,low  (2*numbers)					;Load Z-pointer
 mov r16,r20
 add r16,r20
 add zl,r16
 lpm
 ldi r16,0b11010011
 out portd,r16
 out portb,r0							;Display digit2
 rcall shift

 digit3:
 ldi zh,high (2*numbers)
 ldi zl,low  (2*numbers)					;Load Z-pointer
 mov r16,r21
 add r16,r21
 add zl,r16
 lpm
 ldi r16,0b11110010
 out portd,r16
 out portb,r0							;Display digit3
 rcall shift

 digit4:
 ldi zh,high (2*numbers)
 ldi zl,low  (2*numbers)					;Load Z-pointer
 mov r16,r22
 add r16,r22
 add zl,r16
 lpm
 ldi r16,0b11110001
 out portd,r16
 out portb,r0							;Display digit4
 rcall shift
 rjmp digit1

 ;___________________ UP ____________________

 shift:
 ldi r16,100

 buffer:
 dec r16
 brne buffer
 ldi r16,255
 out portb,r16
 ret

 ;___________________ ISR ___________________

 inte0:
 cli
 in r15,sreg
 push r16
 dec r19
 cpi r19,-1
 brne back
 ldi r19,9
 dec r20
 cpi r20,-1
 brne back
 ldi r20,9
 dec r21
 cpi r21,-1
 brne back
 ldi r21,9
 dec r22
 cpi r22,-1
 brne back
 ldi r22,9
 out sreg,r15
 pop r16
 reti

 inte1:
 cli
 in r15,sreg
 push r16
 inc r19
 cpi r19,10
 brne back
 ldi r19,0
 inc r20
 cpi r20,10
 brne back
 ldi r20,0
 inc r21
 cpi r21,10
 brne back
 ldi r21,0
 inc r22
 cpi r22,10
 brne back
 ldi r22,0
 out sreg,r15
 pop r16
 reti

 back:
 out sreg,r15
 pop r16
 reti

 ;__________________ Tables _________________

 numbers:
 .dw 0b10000001			;0
 .dw 0b11110011			;1
 .dw 0b01001001			;2
 .dw 0b01100001			;3
 .dw 0b00110011			;4
 .dw 0b00100101			;5
 .dw 0b00000101			;6
 .dw 0b11110001			;7
 .dw 0b00000001			;8
 .dw 0b00100001			;9
