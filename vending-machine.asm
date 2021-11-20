.data

titulo:         .asciiz "\n******** Maquina expendedora de bebidas ******** \n\n"
bebida:		    .asciiz "\n\nIngrese el codigo de la bebida o '0' para cancelar: "
sel:            .asciiz "Seleccionaste  "
dineroingresado:.asciiz	"\nEl dinero ingresado para la compra es de: $"
cancelar:       .asciiz "\n--Has cancelado la compra, dinero devuelto ---> $"
cambio:         .asciiz "Su cambio es: "
verificado:	    .asciiz "El monto ingresado es el correcto!\n"   
procesado:	    .asciiz "Se proceso su compra, disfruta tu bebida ^-^\n" 
dinero:		    .asciiz "Escriba '1' para ingresar dinero o '0' para salir:"
dinero1:	    .asciiz "\nIngrese billetes o '0' para continuar: "
dinero2:	    .asciiz "\nIngrese monedas o '0' para continuar: "
nuevacompra:	.asciiz "\nSi desea seguir comprando digite '1', para salir digite '0':"
nuevacompra2:	.asciiz "\n****** Nueeeeeva Compraaaaa ****** \n\n"
nostock:        .asciiz "Lo sentimos, la bebida esta agotada"
salto_linea: 	.asciiz "\n"
head:	        .asciiz "|---Bebida---|--Costo---|---Codigo---|---Cantidad--|\n"
fila1:          .asciiz "|Agua        |  $0.50   |      1     |      "
fila2:          .asciiz "|Coca Cola   |  $1.00   |      2     |      "
fila3:	        .asciiz "|Sprite      |  $1.00   |      3     |      "
fila4:          .asciiz "|Fanta       |  $0.50   |      4     |      "
fila5:    	    .asciiz "|Gatorade    |  $1.00   |      5     |      "
fila6:    	    .asciiz "\n|Salir       |   ----   |      0     |      -"
finFila:        .asciiz "      |\n"
footer:     	.asciiz "______________________________________\n\n"
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

# Precio de bebidas
precioAgua: 	.float 0.50
precioCocacola: .float 1.00
precioSprite: 	.float 1.00
precioFanta: 	.float 0.50
precioGatorade: .float 1.50

#stock inicial de las Bebidas
aguaCant:       .word 8
cocacolaCant:   .word 8
spriteCant:     .word 8
fantaCant:      .word 8
gatoCant:       .word 8

bajostock:	    .word 2

#Billetes
uno:			.word 1
cinco:			.word 5
diez:			.word 10

#Monedas
cincoMoneda:    .float 0.05
diezMoneda:     .float 0.10
veinticinco:    .float 0.25
cincuenta:      .float 0.50
dolarMoneda:    .word 1

.text
#Cargar stock de bebidas
lw $s2,aguaCant
lw $s3,cocacolaCant
lw $s4,spriteCant
lw $s5,fantaCant
lw $s6,gatoCant

main:
	#cargar stock
	#imprimir titulo
	li $v0, 4
	la $a0,titulo            #"****** Maquina expendedora de bebidas ******"
	syscall

	#-----Inicia tabla-----
	la $a0, head   #imprime en una tabla lo que contiene la máquina.
	syscall

	la $a0, fila1
	syscall
	li $v0,1
	move $a0,$s2
	syscall
	li $v0, 4
	la $a0, finFila
	syscall

	la $a0, fila2
	syscall
	li $v0,1
	move $a0,$s3
	syscall
	li $v0, 4
	la $a0, finFila
	syscall

	la $a0, fila3
	syscall
	li $v0,1
	move $a0,$s4
	syscall
	li $v0, 4
	la $a0, finFila
	syscall

	la $a0, fila4
	syscall
	li $v0,1
	move $a0,$s5
	syscall
	li $v0, 4
	la $a0, finFila
	syscall

	la $a0, fila5
	syscall
	li $v0,1
	move $a0,$s6
	syscall
	li $v0, 4
	la $a0, finFila
	syscall

	la $a0, fila6
	syscall
	la $a0, finFila
	syscall
	la $a0,footer
	syscall
	#-----Termina tabla-----

	#Empieza programa
whileStart:
	la $a0, dinero	            #imprime: 'Escriba '1' para ingresar dinero o '0' para salir:'
	syscall
	li $v0, 5		            #lee entero (validacion salida o ingreso de dinero) por consola
	syscall
	move $s0, $v0		        #muevo el valor a $s0
	beq  $s0, 0, salida	        #salta a salida si se ingresa 0
	bne  $s0, 1, verificarCode  #si no ingresa el '1', se lo pide nuevamente.


# Verificador de dinero
verificarDinero:
	li $v0, 4
	la $a0, dinero1				#se pide ingresar billetes
	syscall
	li $v0, 5	    			#lee el entero (billetes) por consola
	syscall
	move $s1, $v0	    		#muevo el valor a $s1
	jal validarbillete 			#se llama a funcion validar billete

verificarMoneda:
	li $v0,4
	la $a0,dinero2				#se pide ingresar monedas (opcional para el usuario)
	syscall
	li $v0,6	    			#lee float (monedas) por consola
	syscall
	jal validarmoneda			#se llama a funcion validar moneda

	mtc1 $s1, $f1				#conversion del entero al float
	cvt.s.w $f2,$f1				#conversion del entero al float adjunto ref: https://youtu.be/P_drmvt_s1Q
	add.s $f2,$f0,$f2			#se suma las monedas y el billete para operaciones posteriores
	#beq $t2,$zero,error2		#si el dinero ingresado es igual a 0 va a error
	li $v0,4
	la $a0,dineroingresado		#imprime por pantalla el monto que se ha ingresado
	syscall
	li $v0,2
	mov.s $f12,$f2				#se imprime el valor flotante
	syscall

#Comprueba el código de las bebidas.
comprobarCodigo:
	li   $v0, 4
	la   $a0, bebida
	syscall
	li   $v0, 5	    	    	#lee entero (código de bebida) por consola
	syscall
	move $s1, $v0	        	#muevo el valor a $s1
	beq  $s1, 0, cancelarCompra #si el valor del codigo es 0 entonce se va a salida
	slti $t0, $s1, 6    		#si no es = a 0, entonces se hace la condicion que valor de usuario menor a 6
	beq  $t0, 0, error1	    	#si el valor es mayor a 0 va a error


#Proceso de restar cantidad, dar cambio, anuncias falta de bebidas.
proceso:
	move $a0,$s1		#Muevo el codigo de seleccion como argumento
	jal imprimirBebida  #llamo a la funcion imprimirBebida

	la $a0,nuevacompra
	syscall

	li $v0,5
	syscall

	move $t2,$v0
	beq $t2,0,salida
	li $v0,4
	la $a0,nuevacompra2
	syscall

	j main

imprimirBebida:			
	addi $sp, $sp,-4	#guardo en el stack el argumento
	sw   $a0, 0($sp)
	move $t5,$a0        #el argumento lo guardo en un registro temporal '$a0' se usa para otras cosas.
	                    #switch(argumento)
	beq $t5,1,iagua     # case 1: agua
	beq $t5,2,icocacola # case 2: cocacola
	beq $t5,3,isprite   # case 3: sprite
	beq $t5,4,ifanta    # case 4: fanta
	beq $t5,5,igatorade # case 5: gatorade
	regresa:
		addi $sp, $sp, 4
		jr $ra

#Funciones con bebidas
iagua: #s2 -> stock de agua
	li $v0, 4
	la $a0,sel       #Imprime 'seleccionaste Agua'
	syscall
	la $a0, agua 
	syscall

	subi $s2,$s2,1   #restar 1 al stock de agua
			
	la $a0,procesado
	syscall

	la $a0, cambio
	syscall
	l.s $f0, precioAgua
	sub.s $f2,$f2,$f0
	li $v0,2
	mov.s $f12,$f2				#se imprime el valor flotante
	syscall
	j regresa


icocacola: #$s3 -> stock de cocaCola
	li $v0, 4
	la $a0,sel   #Imprime 'seleccionaste coca cola'
	syscall
	la $a0, cocacola 
	syscall

	subi $s3,$s3,1   #restar 1 al stock de cocacola
	la $a0,procesado
	syscall

	la $a0, cambio
	syscall
	# l.s $f0, precioCocacola
	# sub.s $f2,$f2,$f0
	# li $v0,2
	# mov.s $f12,$f2				#se imprime el valor flotante
	# syscall
	j regresa

isprite: #$s4 -> stock de sprite
	li $v0, 4
	la $a0,sel   #Imprime 'seleccionaste sprite'
	syscall
	la $a0, sprite
	syscall

	subi $s4,$s4,1   #restar 1 al stock de sprite

	la $a0,procesado
	syscall

	la $a0, cambio
	syscall
	# l.s $f0, precioSprite
	# sub.s $f2,$f2,$f0
	# li $v0,2
	# mov.s $f12,$f2				#se imprime el valor flotante
	# syscall
	j regresa

ifanta: #s5 -> stock de fanta
	li $v0, 4
	la $a0,sel   #Imprime 'seleccionaste fanta'
	syscall
	la $a0, fanta 
	syscall

	subi $s5,$s5,1   #restar 1 al stock de fanta

	la $a0,procesado
	syscall

	la $a0, cambio
	syscall
	# l.s $f0, precioFanta
	# sub.s $f2,$f2,$f0
	# li $v0,2
	# mov.s $f12,$f2				#se imprime el valor flotante
	# syscall
	j regresa

igatorade: #s6 -> stock de gatorade
	li $v0, 4
	la $a0,sel   #Imprime 'seleccionaste gatorade'
	syscall
	la $a0, gatorade 
	syscall

	subi $s6,$s6,1   #restar 1 al stock de gatorade
	la $a0,procesado
	syscall

	la $a0, cambio
	syscall
	# l.s $f0, precioGatorade
	# sub.s $f2,$f2,$f0
	# li $v0,2
	# mov.s $f12,$f2				#se imprime el valor flotante
	# syscall
	j regresa

#Funciones
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

