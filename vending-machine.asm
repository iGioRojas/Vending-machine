.data                        

titulo:         .asciiz "Maquina expendedora de bebidas:3 \n"
sel:            .asciiz "Seleccionaste  "
total:          .asciiz "El total es: "
cambio:         .asciiz "Su cambio es: "
nostock:        .asciiz "Lo sentimos, la bebida esta agotada"
salto_linea: 	  .asciiz "\n"

# Bebidas en la maquina expendedora
agua:           .asciiz "Agua \n"
aguacongas:     .asciiz "Agua con Gas \n"
cocacola:       .asciiz "Coca Cola \n"
sprite:         .asciiz "Sprite\n"
fanta:		      .asciiz "Fanta \n"
powerade:       .asciiz "Powerade \n"
gatorade:	      .asciiz "Gatorade \n"
vivecien:	      .asciiz "Vive 100 \n"
limonada:	      .asciiz "Limonada Tesalia \n"

#stock inicial de las Bebidas
aguaCant:       .word 10
aguagasCant:    .word 10
cocacolaCant:   .word 10
spriteCant:     .word 10
fantaCant:      .word 10
powerCant:      .word 10
gatoCant:       .word 10
vivecienCant:   .word 10
limonada:       .word 10

#Billetes y monedas
