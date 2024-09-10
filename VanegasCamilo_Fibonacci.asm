.data
    prompt:     .asciiz "Ingrese la cantidad de n�meros de la serie Fibonacci: "
    fib_msg:    .asciiz "Serie Fibonacci: "
    sum_msg:    .asciiz "\nLa suma de los n�meros es: "
    newline:    .asciiz "\n"

.text
    .globl main

main:
    # Pedir al usuario que ingrese cu�ntos n�meros de la serie quiere generar
    li $v0, 4               # C�digo de syscall 4: imprimir string
    la $a0, prompt           # Cargar el mensaje a mostrar
    syscall

    # Leer el n�mero ingresado por el usuario
    li $v0, 5               # C�digo de syscall 5: leer entero
    syscall
    move $t0, $v0           # Guardar el n�mero en $t0 (n�mero de elementos)

    # Inicializar los primeros valores de la serie Fibonacci
    li $t1, 0               # Primer valor de Fibonacci (fib(0))
    li $t2, 1               # Segundo valor de Fibonacci (fib(1))
    li $t3, 2               # Contador para la iteraci�n (ya tenemos los dos primeros valores)
    move $t4, $t0           # Guardar el n�mero de elementos a generar en $t4
    li $t5, 0               # Acumulador para la suma

    # Mostrar el mensaje "Serie Fibonacci: "
    li $v0, 4
    la $a0, fib_msg
    syscall

    # Mostrar fib(0) (el primer n�mero de la serie)
    li $v0, 1               # C�digo de syscall 1: imprimir entero
    move $a0, $t1           # Mostrar fib(0)
    syscall

    # Acumular fib(0) en la suma
    add $t5, $t5, $t1

    # Mostrar fib(1) (el segundo n�mero de la serie)
    li $v0, 1               # C�digo de syscall 1: imprimir entero
    move $a0, $t2           # Mostrar fib(1)
    syscall

    # Acumular fib(1) en la suma
    add $t5, $t5, $t2

    # Ciclo para generar los siguientes n�meros de Fibonacci
fib_loop:
    beq $t3, $t4, print_sum     # Si ya generamos la cantidad de n�meros solicitada, salir del bucle

    # Calcular el siguiente n�mero de la serie
    add $t6, $t1, $t2          # t6 = fib(i-2) + fib(i-1)
    move $t1, $t2              # fib(i-2) = fib(i-1)
    move $t2, $t6              # fib(i-1) = fib(i)

    # Imprimir el n�mero actual de Fibonacci
    li $v0, 1                  # C�digo de syscall 1: imprimir entero
    move $a0, $t6              # Mostrar el n�mero actual
    syscall

    # Acumular en la suma
    add $t5, $t5, $t6

    # Incrementar el contador
    addi $t3, $t3, 1
    j fib_loop                 # Repetir el ciclo

print_sum:
    # Mostrar un salto de l�nea
    li $v0, 4
    la $a0, newline
    syscall

    # Mostrar el mensaje "La suma de los n�meros es: "
    li $v0, 4
    la $a0, sum_msg
    syscall

    # Imprimir la suma acumulada
    li $v0, 1                  # C�digo de syscall 1: imprimir entero
    move $a0, $t5              # Imprimir la suma
    syscall

    # Terminar el programa
    li $v0, 10                 # C�digo de syscall 10: terminar
    syscall
