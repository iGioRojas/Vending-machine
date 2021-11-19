.data                        

titulo:         .asciiz "\n****** Maquina expendedora de bebidas ****** \n\n"
bebida:		.asciiz "Escriba el código de la bebida:"
sel:            .asciiz "Seleccionaste  "
total:          .asciiz "El total es: "
cambio:         .asciiz "Su cambio es: "
nostock:        .asciiz "Lo sentimos, la bebida esta agotada"
salto_linea: 	.asciiz "\n"
presentar1:	.asciiz "|---Bebida---|--Costo---|---Código---|\n|Agua\t\t$0.50\t\t1    |\n|Coca Cola\t$1\t\t2    |\n"
presentar2:	.asciiz "|Sprite\t\t$1\t\t3    |\n|Fanta\t\t$0.50\t\t4    |\n|Gatorade\t$1\t\t5    |\n"
presentar3: 	.asciiz "______________________________________\n\n"
error:		.asciiz "\n\n****El código ingresado no existe, intente de nuevo...\n"


# Bebidas en la maquina expendedora
agua:           .asciiz "Agua\n"
cocacola:       .asciiz "Coca Cola\n"
sprite:         .asciiz "Sprite\n"
fanta:		.asciiz "Fanta\n"
gatorade:       .asciiz "Gatorade\n"


#stock inicial de las Bebidas
aguaCant:       .word 10
cocacolaCant:   .word 10
spriteCant:     .word 10
fantaCant:      .word 10
gatoCant:       .word 10

#Billetes 
uno:	.word 1
cinco:	.word 5	
diez:	.word 10
#Monedas
cincoMoneda: .float 0.05
diezMoneda:  .float 0.10
veinticinco: .float 0.25
cincuenta:   .float 0.50
dolarMoneda: .word 1

.text

#imprimir titulo
li $v0, 4
la $a0,titulo
syscall

#imprime tabla
la $a0, presentar1
syscall

la $a0,presentar2
syscall

la $a0,presentar3
syscall

#imput de bebida
la $a0,bebida
syscall
		 
comprobarCodigo: li $v0,5	    #lee entero por consola
		 syscall
		 move $s0,$v0	    #muevo el valor a $s0
		 slti $t0,$s0,6     #valor de usuario menor a 6
		 beq $t0,1,error1

error1:
	li $v0,4
	la $a0,error
	syscall
	j comprobarCodigo
