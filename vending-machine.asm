.data

titulo:         .asciiz "\n******** Máquina expendedora de bebidas ******** \n\n"
bebida:		.asciiz "\n\nIngrese el código de la bebida o '0' para cancelar: "
sel:            .asciiz "Seleccionaste  "
dineroingresado:.asciiz	"\nEl dinero ingresado para la compra es de: $"
cancelar:       .asciiz "\n--Se ha cancelado la compra, dinero devuelto ---> $"
cambio:         .asciiz "Su cambio es: "
verificado:	.asciiz "El monto ingresado es el correcto!\n"   
procesado:	.asciiz "Se procesó su compra, disfruta tu bebida ^-^\n\n" 
dinero:		.asciiz "\nEscriba '1' para ingresar dinero o '0' para salir:"
dinero1:	.asciiz "\nIngrese billetes (1, 5, 10) sin '$' o '0' para continuar: "
dinero2:	.asciiz "\nIngrese monedas o '0' para continuar: "
nuevacompra:	.asciiz "\n\nSi desea seguir comprando ingrese cualquier número, para salir digite '0':"
nuevacompra2:	.asciiz "\n****** Nueeeeeva Compraaaaa ****** \n\n"
nostock:        .asciiz "\n [ADVERTENCIA ] --> Bajo stock de "
salto_linea: 	.asciiz "\n"
head:	        .asciiz "|---Bebida---|--Costo---|---Codigo---|---Cantidad--|\n"
fila1:          .asciiz "|Agua        |  $0.50   |      1     |      "
fila2:          .asciiz "|Coca Cola   |  $1.00   |      2     |      "
fila3:	        .asciiz "|Sprite      |  $1.00   |      3     |      "
fila4:          .asciiz "|Fanta       |  $0.50   |      4     |      "
fila5:    	.asciiz "|Gatorade    |  $1.00   |      5     |      "
fila6:    	.asciiz "\n|Salir       |   ----   |      0     |      -"
finFila:        .asciiz "      |\n"
footer:     	.asciiz "______________________________________\n"
mensajeSalida:	.asciiz "\n\n****Gracias por su compra...****\n"
error:		.asciiz "\n\n****El código ingresado no existe, intente de nuevo...\n"
errorDinero:	.asciiz "\n\n****El monto ingresado no existe, intente de nuevo...\n"
errorNumero:    .asciiz "\n[ERROR] ---> Solo se acepta el valor de '1' y '0', intente de nuevo...\n"
faltaDinero:    .asciiz "\nEl monto agregado no alcanza para la bebida, dinero devuelto --> "

# Bebidas en la maquina expendedora
agua:           .asciiz "Agua\n"
cocacola:       .asciiz "Coca Cola\n"
sprite:         .asciiz "Sprite\n"
fanta:		.asciiz "Fanta\n"
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

bajostock:	.word 3  #el porcenta es aproximado a 1.2 lo redondeamos a 2, para comparar 2<3

#Billetes
uno:		.word 1
cinco:		.word 5
diez:		.word 10

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
lw $s7,bajostock


main:
	#imprimir titulo
	li $v0, 4
	la $a0,titulo            #"****** Maquina expendedora de bebidas ******"
	syscall

	#-----Inicia tabla-----
	la $a0, head             #imprime en una tabla lo que contiene la máquina.
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
		
	#Empieza programa principal
whileStart:
	la $a0, dinero	            #imprime: 'Escriba '1' para ingresar dinero o '0' para salir:'
	syscall
	li $v0, 5		    #lee un número entero por consola
	syscall
	move $s0, $v0		    #muevo el valor ingresado al registro $s0
	beq  $s0, 0, salida         #salta a la salida si se ingresa 0
	bne  $s0, 1, verificarCode  #si no ingresa el '1', se lo pide nuevamente


        # Verificador de dinero
verificarDinero:
	li $v0, 4
	la $a0, dinero1	            #Se pide el ingreso de billetes (1,5,10)
	syscall
	li $v0, 5	    	    #lee el valor del billete
	syscall
	move $s1, $v0	    	    #muevo el valor ingresado al registro $s1
	jal validarbillete 	    #se llama la función para validar el billete

verificarMoneda:
	li $v0,4
	la $a0,dinero2              #se pide ingresar monedas (opcional para el usuario, 0 si no quiere ingresar monedas)
	syscall
	li $v0,6	    	    #lee el ingreso de la moneda por consola
	syscall
	jal validarmoneda
	
dineroprocesado:
	mtc1 $s1, $f1		    #conversion del entero (billete) al float
	cvt.s.w $f1,$f1		    #conversion del entero (billete) al float adjunto ref: https://youtu.be/P_drmvt_s1Q
	add.s $f2,$f0,$f1	    #se suma las monedas y el billete para operaciones posteriores
	li $t1,0	            # t1 = 0
	mtc1 $t1, $f3		    #conversion del entero CERO al float
	cvt.s.w $f3,$f3		    #conversion del entero CERO al float adjunto ref: https://youtu.be/P_drmvt_s1Q
	c.eq.s $f2,$f3	
	bc1t error2
	li $v0,4
	la $a0,dineroingresado      #imprime por pantalla el monto que se ha ingresado
	syscall
	li $v0,2
	mov.s $f12,$f2		    #se imprime el valor flotante
	syscall

        #Comprueba el código de las bebidas.
comprobarCodigo:
	li   $v0, 4
	la   $a0, bebida
	syscall
	li   $v0, 5	    	    	#lee entero (código de bebida) por consola
	syscall
	move $s1, $v0	        	#muevo el valor ingresado a $s1
	beq  $s1, 0, cancelarCompra 	#si el valor del código es 0 entonce se va a salida
	slti $t0, $s1, 6    		#si no es = a 0, entonces se hace la condicion que valor de usuario menor a 6
	beq  $t0, 0, error1	    	#si el valor es mayor a 0 va a error


       #Proceso de restar cantidad, dar cambio, anunciar falta de bebidas.
proceso:
	move $a0,$s1		        #Muevo el código de la bebidad ingresada como argumento
	jal imprimirBebida              #llamo a la funcion imprimirBebida
	li $v0,4
	la $a0,nuevacompra		#se le pide al usuario cualquier número o '0' para salir
	syscall
	li $v0,5			#lee el número ingresado
	syscall
	move $t2,$v0
	beq $t2,0,salida                # si es 0 cierra el programa
	li $v0,4
	la $a0,nuevacompra2             #Imprime "Nueva compra"
	syscall
	
reinicio:
	#reinicia los valores para una nueva compra
	li $t1,0
	mtc1 $t1,$f2
	j main

imprimirBebida:			
	addi $sp, $sp,-4               #guardo en el stack el argumento
	sw   $a0, 0($sp)
	move $t5,$a0                   #el argumento lo guardo en un registro temporal '$a0' se usa para validar la bebida.
	                               #switch(argumento)
	beq $t5,1,iagua                # case 1: agua
	beq $t5,2,icocacola            # case 2: cocacola
	beq $t5,3,isprite              # case 3: sprite
	beq $t5,4,ifanta               # case 4: fanta 
	beq $t5,5,igatorade            # case 5: gatorade
	
	regresa:
		addi $sp, $sp, 4       #devuelve al stack su valor original
		jr $ra                 #retorna a la linea 209

#Funciones con bebidas
iagua:  #s2 -> stock de agua
	#-----STOCK: Verifica si el stock es igual al minimo permitido
	slt $t3,$s2,$s7                #compara stock inicial < minimo permitido
	beq $t3, 1,bajostockAgua       #si es verdadero salta a bajostockAgua

iagua2:
	beq $s2,0,cancelarCompra       #si no hay stock se cancela la compra y se devuelve el dinero
	l.s $f0, precioAgua            #cargamos el precio del agua
	c.le.s $f2,$f0                 #confirmamos que el precio del usuario sea mayor al precio del agua
	bc1t dineroMal                 #si el dinero no alcanza saltamos a dineroMal
	
	li $v0, 4                      #si todo esta correcto le decimos al usuario que bebida escogio
	la $a0,sel                     #Imprime 'seleccionaste'
	syscall
	la $a0, agua                   #Imprime 'Agua'
	syscall

	subi $s2,$s2,1                 #resta 1 al stock de agua
			
	la $a0,procesado               #imprime "Se proceso la compra"
	syscall

	la $a0, cambio                 #imprime "su cambio es"
	syscall
	sub.s $f2,$f2,$f0              #se le resta el precio del agua al dinero ingresado
	li $v0,2
	mov.s $f12,$f2		       #se imprime su cambio (flotante)
	syscall
	j regresa                      #regresa a la función imprimirBebida


icocacola: #$s3 -> stock de cocaCola
	#-----STOCK: Verifica si el stock es igual al minimo permitido
	slt $t3,$s3,$s7                #compara stock inicial < minimo permitido
	beq $t3, 1,bajostockCoca       #si es verdadero salta a bajostockCoca
icocacola2:
	beq $s3,0,cancelarCompra       #si no hay stock se cancela la compra y se devuelve el dinero
	l.s $f0, precioCocacola        #se carga el precio de la coca cola
	c.le.s $f2,$f0                 #confirmamos que el precio del usuario sea mayor al precio de coca cola
	bc1t dineroMal		       #si el dinero no alcanza saltamos a dineroMal
	li $v0, 4
	la $a0,sel                     #Imprime 'seleccionaste'
	syscall
	la $a0, cocacola               #Imprime 'coca cola'
	syscall

	subi $s3,$s3,1                 #resta 1 al stock de cocacola
	la $a0,procesado               #imprime "Se proceso la compra"
	syscall

	la $a0, cambio                 #imprime "su cambio es"
	syscall
	sub.s $f2,$f2,$f0              #se le resta el precio de coca cola al dinero ingresado
	li $v0,2
	mov.s $f12,$f2		       #se imprime el valor flotante
	syscall 
	j regresa                      #regresa a la función imprimirBebida

isprite: #$s4 -> stock de sprite
	#-----STOCK: Verifica si el stock es igual al minimo permitido
	slt $t3,$s4,$s7                #compara stock inicial < minimo permitido
	beq $t3, 1,bajostockSprite     #si es verdadero salta a bajostockSprite
isprite2:
	beq $s4,0,cancelarCompra       #si no hay stock se cancela la compra y se devuelve el dinero
	l.s $f0, precioSprite          #se carga el precio de la sprite
	c.le.s $f2,$f0                 #confirmamos que el precio del usuario sea mayor al precio de sprite
	bc1t dineroMal                 #si el dinero no alcanza saltamos a dineroMal
	li $v0, 4
	la $a0,sel                     #Imprime 'seleccionaste'
	syscall
	la $a0, sprite                 #Imprime 'sprite'
	syscall

	subi $s4,$s4,1                 #resta 1 al stock de sprite

	la $a0,procesado               #imprime "Se proceso la compra"
	syscall 

	la $a0, cambio                 #imprime "su cambio es"
	syscall
	sub.s $f2,$f2,$f0              #se le resta el precio de sprite al dinero ingresado
	li $v0,2
	mov.s $f12,$f2		       #se imprime el valor flotante
	syscall
	j regresa                      #regresa a la función imprimirBebida

ifanta: #s5 -> stock de fanta
	#-----STOCK: Verifica si el stock es igual al minimo permitido
	slt $t3,$s5,$s7                #compara stock inicial < minimo permitido
	beq $t3, 1,bajostockFanta      #si es verdadero salta a bajostockFanta
ifanta2:
	beq $s5,0,cancelarCompra       #si no hay stock se cancela la compra y se devuelve el dinero
	l.s $f0, precioFanta	       #se carga el precio de fanta
	c.le.s $f2,$f0                 #confirmamos que el precio del usuario sea mayor al precio de fanta
	bc1t dineroMal                 #si el dinero no alcanza saltamos a dineroMal
	li $v0, 4
	la $a0,sel                     #imprime 'seleccionaste'
	syscall
	la $a0, fanta                  #imprime 'fanta'
	syscall

	subi $s5,$s5,1                 #resta 1 al stock de fanta

	la $a0,procesado               #imprime "Se proceso la compra"
	syscall
 
	la $a0, cambio                 #imprime "su cambio es"
	syscall           
	sub.s $f2,$f2,$f0              #se le resta el precio de fanta al dinero ingresado
	li $v0,2
	mov.s $f12,$f2		       #se imprime el valor flotante
	syscall
	j regresa                      #regresa a la función imprimirBebida

igatorade: #s6 -> stock de gatorade
	#-----STOCK: Verifica si el stock es igual al minimo permitido
	slt $t3,$s6,$s7                #compara stock inicial < minimo permitido
	beq $t3, 1,bajostockGato       #si es verdadero salta a bajostockGato
igatorade2:
	beq $s6,0,cancelarCompra       #si no hay stock se cancela la compra y se devuelve el dinero
	l.s $f0, precioGatorade        #se carga el precio de Gatorade
	c.le.s $f2,$f0                 #confirmamos que el precio del usuario sea mayor al precio de gatorade
	bc1t dineroMal                 #si el dinero no alcanza saltamos a dineroMal
	li $v0, 4
	la $a0,sel                     #imprime 'seleccionaste'
	syscall
	la $a0, gatorade               #imprime 'gatorade'
	syscall

	subi $s6,$s6,1                 #resta 1 al stock de gatorade
	la $a0,procesado               #imprime "Se proceso la compra"
	syscall

	la $a0, cambio                 #imprime "su cambio es"
	syscall
	sub.s $f2,$f2,$f0              #se le resta el precio de gatorade al dinero ingresado
	li $v0,2
	mov.s $f12,$f2	               #se imprime el valor flotante
	syscall
	j regresa                      #regresa a la función imprimirBebida


bajostockAgua:
	li $v0,4                       #bajostockAgua imprime lo siguiente
	la $a0,nostock                 #"[ADVERTENCIA ] --> Bajo stock de 
	syscall 
	la $a0,agua                    #Agua
	syscall
	la $a0,salto_linea             #\n"
	syscall
	j iagua2                       #salta a iagua2

bajostockCoca:
	li $v0,4                       #bajostockCoca imprime lo siguiente
	la $a0,nostock                 #"[ADVERTENCIA ] --> Bajo stock de
	syscall 
	la $a0,cocacola                #Coca Cola
	syscall
	la $a0,salto_linea             #\n"
	syscall
	j icocacola2                   #salta a icocacola2

bajostockSprite:                 
	li $v0,4                       #bajostockSprite imprime lo siguiente
	la $a0,nostock                 #"[ADVERTENCIA ] --> Bajo stock de
	syscall 
	la $a0,sprite                  #Sprite
	syscall
	la $a0,salto_linea             #\n"
	syscall
	j isprite2                     #salta a isprite2

bajostockFanta:                  
	li $v0,4                       #bajostockFanta imprime lo siguiente
	la $a0,nostock                 #"[ADVERTENCIA ] --> Bajo stock de
	syscall 
	la $a0,fanta                   #Fanta
	syscall
	la $a0,salto_linea             #\n"
	syscall
	j ifanta2

bajostockGato:
	li $v0,4                       #bajostockGato imprime lo siguiente
	la $a0,nostock                 #"[ADVERTENCIA ] --> Bajo stock de
	syscall 
	la $a0,gatorade                #Gatorade
	syscall
	la $a0,salto_linea             #\n"
	syscall
	j igatorade2

#Funciones
validarbillete:
	move $t1, $v0                  #Movemos el valor ingresado por el usuario al registro $t1
	beq  $t1, 0, volver            #si el valor es 0, se regresa a la linea 164
	lw   $t2, uno                  #cargamos el valor del billete uno
	bne  $t1, $t2,billete5         #si el billete no es uno, salta a billete5
	j    valb                      #si el billete es uno, salta a valb (válido billete)
billete5:
	lw   $t3, cinco                #cargamos el valor del billete 5
	bne  $t1, $t3, billete10       #si el billete no es 5, salta a billete10
	j    valb                      #si el billete es 5, salta a valb
billete10:
	lw   $t4, diez                 #cargamos el valor del billete 10
	bne  $t1, $t4, error2          #si el billete no es 10, salta a dar error ya que son los únicos billetes que la máquina acepta.

valb:
	li $v0, 4                      #imprime "El monto ingresado es el correcto!\n"
	la $a0, verificado
	syscall
	jr $ra                         #regresa al lugar donde fue llamado, linea 162

volver:
	jr $ra                         #regresa al lugar donde fue llamado, linea 162


validarmoneda:
	li $t2,0		       # t1 = 0
	mtc1 $t2, $f3		       #conversion del entero CERO al float
	cvt.s.w $f3,$f3		       #conversion del entero CERO al float adjunto ref: https://youtu.be/P_drmvt_s1Q
	c.eq.s $f0,$f3
	bc1t dineroprocesado
	l.s $f4,cincoMoneda
	c.eq.s $f0,$f4
	bc1f moneda10
	j valm
moneda10: 
	l.s $f5,diezMoneda
	c.eq.s $f0,$f5
	bc1f moneda25
	j valm
moneda25:
	l.s $f6,veinticinco
	c.eq.s $f0,$f6
	bc1f moneda50
	j valm
moneda50:	
	l.s $f7,cincuenta
	c.eq.s $f0,$f7
	bc1f moneda100
	j valm
moneda100:
	lw $t2,dolarMoneda		        # t2 = 1
	mtc1 $t2, $f3				#conversion del entero 1 al float
	cvt.s.w $f3,$f3				#conversion del entero 1 al float adjunto ref: https://youtu.be/P_drmvt_s1Q
	c.eq.s $f0,$f3
	bc1f errorMoneda

valm:
	li $v0, 4
	la $a0, verificado
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
	la $a0, cancelar        #se imprime "se ha cancelado la compra"
	syscall
	li $v0,2
	mov.s $f12,$f2		#se imprime el valor flotante
	syscall
	li $v0, 4
	la $a0,salto_linea      #\n
	syscall
	j salida
	
dineroMal:
	li $v0,4
	la $a0,faltaDinero      #imprime "\nEl monto agregado no alcanza para la bebida, dinero devuelto --> " 
	syscall
	li $v0,2
	mov.s $f12,$f2		#se imprime el valor flotante
	syscall
	li $v0,4
	la $a0,salto_linea
	syscall
	j reinicio              #se reincia el programa
