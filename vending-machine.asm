.data

titulo:         .asciiz "\n******** Maquina expendedora de bebidas ******** \n\n"
bebida:		    .asciiz "\n\nEscriba el codigo de las bebidas o '0' para cancelar: "    #hay que cambiar la orden a una mas wonita:C
sel:            .asciiz "Seleccionaste  "
dineroingresado:.asciiz	"\nEl dinero ingresado para la compra es de: $"
cancelar:       .asciiz "\n--Has cancelado la compra, dinero devuelto ---> $"
cambio:         .asciiz "Su cambio es: "
verificado:	    .asciiz "El monto ingresado es el correcto!\n"   #quitar en algun futuro
procesado:	    .asciiz "Tabien, se proceso tu compra\n" #quitar en algun futuro
dinero:		    .asciiz "Escriba '1' para ingresar dinero o '0' para salir:"
dinero1:	    .asciiz "\nIngrese billetes o '0' para continuar: "
dinero2:	    .asciiz "\nIngrese monedas o '0' para continuar: "
nuevacompra:	.asciiz "\nSi desea seguir comprando digite '1', para salir digite '0':"
nuevacompra2:	.asciiz "\n****** Nueeeeeva Compraaaaa ****** \n\n"
nostock:        .asciiz "Lo sentimos, la bebida esta agotada"
salto_linea: 	.asciiz "\n\n"
presentar1:	    .asciiz "|---Bebida---|--Costo---|---Codigo---|\n|Agua\t\t$0.50\t\t1    |\n\|Coca Cola\t$1\t\t2    \n"
presentar2:	    .asciiz "\|Sprite\t\t$1\t\t3    |\n|Fanta\t\t$0.50\t\t4    |\n|Gatorade\t$1\t\t5    |\n"
presentar3:	    .asciiz "\n|Salir\t\t----\t\t0    |\n"
presentar4: 	.asciiz "______________________________________\n\n"
mensajeSalida:	.asciiz "\n\n****Gracias por su compra...****\n"
error:		    .asciiz "\n\n****El codigo ingresado no existe, intente de nuevo...\n"
errorDinero:	.asciiz "\n\n****El monto ingresado no existe, intente de nuevo...\n"
errorNumero:     .asciiz "\n[ERROR] ---> Solo se acepta el valor de '1' y '0', intente de nuevo...\n"
# Bebidas en la maquina expendedora
agua:           .asciiz "Agua\n"
cocacola:       .asciiz "Coca Cola\n"
sprite:         .asciiz "Sprite\n"
fanta:		    .asciiz "Fanta\n"
gatorade:       .asciiz "Gatorade\n"

#stock inicial de las Bebidas
aguaCant:       .word 10
cocacolaCant:   .word 10
spriteCant:     .word 10
fantaCant:      .word 10
gatoCant:       .word 10

bajostock:	.word 2

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

main:
	#imprimir titulo
	li $v0, 4
	la $a0,titulo            #"****** Maquina expendedora de bebidas ******"
	syscall

	la $a0, presentar1   #imprime en una tabla lo que contiene la máquina.
	syscall

	la $a0, presentar2
	syscall

	la $a0, presentar3
	syscall

	la $a0, presentar4
	syscall

whileStart:
	la $a0, dinero	    #imprime: 'Escriba '1' para ingresar dinero o '0' para salir:'
	syscall
	li $v0, 5		    #lee entero (validacion salida o ingreso de dinero) por consola
	syscall
	move $s0, $v0		#muevo el valor a $s0
	beq  $s0, 0, salida	#salta a salida si se ingresa 0
	bne  $s0, 1, verificarCode  #si no ingresa el '1', se lo pide nuevamente.


# Verificador de dinero
verificarDinero:
	li $v0, 4
	la $a0, dinero1		#se pide ingresar billetes
	syscall
	li $v0, 5	    	#lee el entero (billetes) por consola
	syscall
	move $s1, $v0	    #muevo el valor a $s1
	jal validarbillete 	#se llama a funcion validar billete

verificarMoneda:
	li $v0,4
	la $a0,dinero2		#se pide ingresar monedas (opcional para el usuario)
	syscall
	li $v0,6	    	#lee float (monedas) por consola
	syscall
	jal validarmoneda	#se llama a funcion validar moneda

	mtc1 $s1, $f1		#conversion del entero al float o eso creo xd
	cvt.s.w $f2,$f1		#conversion del entero al float o eso creo xd adjunto ref: https://youtu.be/P_drmvt_s1Q
	add.s $f2,$f0,$f2	#se suma las monedas y el billete para operaciones posteriores
	#beq $t2,$zero,error2	#si el dinero ingresado es igual a 0 va a error
	li $v0,4
	la $a0,dineroingresado	#imprime por pantalla el monto que se ha ingresado
	syscall
	li $v0,2
	mov.s $f12,$f2		#se imprime el valor flotante
	syscall

#Comprueba el código de las bebidas.
comprobarCodigo:
	li   $v0, 4
	la   $a0, bebida
	syscall
	li   $v0, 5	    	    #lee entero (código de bebida) por consola
	syscall
	move $s1, $v0	        #muevo el valor a $s1
	beq  $s1, 0, cancelarCompra 	#si el valor del codigo es 0 entonce se va a salida
	slti $t0, $s1, 6    	#si no es = a 0, entonces se hace la condicion que valor de usuario menor a 6
	beq  $t0, 0, error1	    #si el valor es mayor a 0 va a error


#aqui se supune que debe restar el dinero ingresado con el valor de la soda, tambien dar el cambio, restar el stock de las bebidas, dios sabra que mas ....
proceso:
	li $v0,4
	la $a0, sel
	syscall
	la $a0,procesado
	syscall
	la $a0,nuevacompra
	syscall
	li $v0,5
	syscall
	move $s2,$v0
	beq $s2,0,salida
	li $v0,4
	la $a0,nuevacompra2
	syscall
	j main


#Funciones (aunque yo hubiera querido hacer todo con bne xd )
validarbillete:
	move $t1, $v0
	beq  $t1, 0, volver
	beq  $t1, $0, error2
	lw   $t2, uno
	bne  $t1, $t2,billete5
	j    valb
billete5:
	lw   $t3, cinco
	bne  $t1, $t3, billete10
	j    valb
billete10:
	lw   $t4, diez
	bne  $t1, $t4, error2

valb:
	li $v0, 4
	la $a0, verificado
	syscall
	jr $ra

volver:
	jr $ra


validarmoneda:
#	move $t1,$v0
#	beq $t1,$0,error2
#	lw $t2, cincoMoneda
#	bne $t1,$t2,moneda10
#	j  valm
#moneda10:
#	lw $t3, diezMoneda
#	bne $t1,$t3,moneda25
#	j valm
#moneda25:
#	lw $t4, veinticinco
#	bne $t1,$t4,moneda50
#	j valm
#moneda50:
#	lw $t5, cincuenta
#	bne $t1,$t5,moneda100
#	j valm
#moneda100:
#	lw $t6, dolarMoneda
#	bne $t1,$t6, error2
#valm:
	li $v0,4
	la $a0,verificado
	syscall
	jr $ra



#Mensajes de error
error1:
	li $v0,4
	la $a0,error		#se imprime mensaje de escritura incorrecta de codigo de bebidas
	syscall
	j comprobarCodigo	#salta al loop comprobarCodigo

error2:
	li $v0,4
	la $a0,errorDinero	#se imprime mensaje de error en el ingreso del Dinero
	syscall
	j verificarDinero	#salta al loop de verificar dinero

errorMoneda:
	li $v0,4
	la $a0,errorDinero	#se imprime mensaje de error en el ingreso del Dinero
	syscall
	j verificarMoneda	#salta al loop de verificar dinero

verificarCode:
	li $v0, 4
	la $a0,errorNumero  # imprime [ERROR] ---> Solo se acepta el valor de '1' y '0', intente de nuevo...
	syscall
	j whileStart

#Salidaa
salida:
	li $v0, 4
	la $a0, mensajeSalida	#mensaje de fin de la transaccion
	syscall
	li $v0, 10		#Se detiene el programa
	syscall

cancelarCompra:
	li $v0, 4
	la $a0, cancelar
	syscall
	li $v0,2
	mov.s $f12,$f2		#se imprime el valor flotante
	syscall
	li $v0, 4
	la $a0,salto_linea
	syscall
	j main
