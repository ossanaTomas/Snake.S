.global cuadrado
	//genera un cuadrado o rectangulo con un tam, pos y color
	
.global dibujar_circulo
   // genera un circulo pasando def de  radio, centro(x,y) y color

.global generateRandomPosition
//genera numeros aleatorios ente 2 y 14 para multiplicar por el tamaño de grilla

.global Ledverde
//enciende el led verde durante un determinado tiempo 

.global Ledrojo
// enciende el led rojo durante un determinado tiempo

.global LedAmbos
// enciende ambos leds. 
	
// deberia limpiar x16


.equ radio, 15 
.equ radioCuadrado, 225
//----------------------------------------------------------------------------------------------------------------------------------------------------
cuadrado: 

    
    mov x1,x14 

	Loop_filasY:
		
		MOV x17, x12    // Restaurar valor inicial de X-columna para cada nueva fila
        MOV x14, x1  // ancho- Restaurar ancho del cuadrado para la siguiente fila  ACA MODICICA ANCHO
	
			Loop_columnasX:
			                            // Calcular direccion para pintar
					MUL x16, x11, x13    		// x16 = i * n
					ADD x16, x16, x17   	    // x16 = (i * n) + j
					LSL x16, x16, #1    		// x16 =  2* ((i * n) + j)
					ADD x16, x16, x0     		// x16 = A + 2 * (i * n + j)
					STURH w4, [x16, #0]  		// pintar la posición X16
    
					ADD x17, x17, #1			// Incrementar indice de columna-> siguiente x
  
					SUBS x14, x14, #1       // Comprobar si hemos alcanzado el final del ancho del cuadrado j=x14
					CBZ x14, Fin_ColumnasX   //si lo alcanzamos, terminamos con X en esta fila, nesesitamos ir a pintar la siguiente
			
				B Loop_columnasX            // si no, sigo pintando 
    
			Fin_ColumnasX:
    
		ADD x13, x13, #1  // Incrementar indice de fila-> siguiente Y
       SUBS x15, x15, #1  // Comprobar si hemos alcanzado el final del alto del cuadrado
     CBZ x15, Fin_Cuadrado  // si alcanzamos el alto, fin cuadrado. 
	
     B Loop_filasY
    
Fin_Cuadrado:

	br X30




//------------------------FUNCION RANDOM-------------------------------------------------
// funcion adaptada para generar numeros aleatorios entre 2 y 14
// una vez que tengo estos numeros lo que hagos es multiplicarlos por 32, para asi
// obtener una cordenada de pixeles (X,Y). 
// Pensada para entrar a funcionar antes de circulo, dado que gurda el resutado
// en x18 y x19, variables de posicion de la funcion circulo

generateRandomPosition:
    // Generar el primer número aleatorio (coordenada X)
    mrs x18, CNTPCT_EL0        // Lee el contador de tiempo del sistema
    and x18, x18, #0x0E        // Toma los 4 bits menos significativos (0 a 14)
    cmp x18, #14               // Si el número es 14
    b.eq adjust_x18            // Saltar si x18 es 14
    add x18, x18, #2           // Ajusta el rango a 2-15 (si x18 no es 14)
    b end_x18_adjustment

adjust_x18:
    add x18, x18, #1           // Ajusta el rango a 2-15 (si x18 es 14)

end_x18_adjustment:

    // Generar el segundo número aleatorio (coordenada Y)
    mrs x19, CNTPCT_EL0        // Lee el contador de tiempo del sistema nuevamente
    lsr x19, x19, #1           // Desplaza el contador para evitar repetición inmediata
    and x19, x19, #0x0E        // Toma los 4 bits menos significativos (0 a 14)
    cmp x19, #14               // Si el número es 14
    b.eq adjust_x19            // Saltar si x19 es 14
    add x19, x19, #2           // Ajusta el rango a 2-15 (si x19 no es 14)
    b end_x19_adjustment

adjust_x19:
    add x19, x19, #1           // Ajusta el rango a 2-15 (si x19 es 14)

end_x19_adjustment:

    // Multiplicar por 32 para obtener la posición en píxeles
    lsl x18, x18, #5           // Multiplica x18 (coordenada X) por 32
    lsl x19, x19, #5           // Multiplica x19 (coordenada Y) por 32

br x30



//----------------------------------------------------------------------------------------------------------------------------------

dibujar_circulo:

    sub x18, x18, #16    // para alinear con multiplos de 32, resto el radio de mi circulo a 
	sub x19, x19, #16    // las variables de inicio. obtengo funcionalidad de grilla. 

    mov x4, radio
    MUL x4, x4, x4      // calculamos radio^2 
    // recorer el cuadrado delimitador alrededor del circulo
    SUB x5, x18, radio     // inicioX = centroX - radio
    ADD x6, x18, radio     // endX = centroX + radio
    SUB x7, x19, radio     // inicioY = centroY - radio
    ADD x8, x19, radio     // endY = centroY + radio

    MOV x9, x7          // y = incioY

outer_loop:
		CMP x9, x8          // while (y <= endY)
		BGT end_outer_loop

		MOV x10, x5         // x = inicioX
		
			inner_loop:
				CMP x10, x6         // while (x <= endX)
				BGT end_inner_loop

    // Calculamos dx^2 y dy^2
				SUB x16, x10, x18   // dx = x - centroX
				MUL x16, x16, x16   // dx^2

				SUB x12, x9, x19    // dy = y - centroY
				MUL x12, x12, x12   // dy^2

			// Checkeamos si el punto (x, y) esta dentro del circulo
				ADD x13, x16, x12   // dx^2 + dy^2
				CMP x13, x4         // compare with radius^2
				BGT skip_pixel      //  si x13, > r^2 , salta, sino, pinta el pixel

				// Calculamos el pixel exacto a pintar, esto usa lo mismo que el cuadrado, podria ser otra funcion a la que se llama.
				MUL x14, x9, x11    // y * N
				ADD x14, x14, x10   // (y * N) + x
				LSL x14, x14, #1    // 2*(y * N) + x 
				ADD x14, x14, x0    // base address + offset=  A+ 2*(y * N) + x 
				
				STRH w15, [x14]     //pinta!!

				skip_pixel:
				ADD x10, x10, #1    // x++
				B inner_loop        

			end_inner_loop:
			
		ADD x9, x9, #1      // y++
	B outer_loop

end_outer_loop:
   
 
   br X30



//------------------------- Fondo ---------------------------------






//----------------------------------------LEDS----------------------------------------------------
Ledverde: 
     mov w21, #0x40							// pongo el bit 9 en 1, esto es 001000000000
	 str w21, [x20, 0]                      //guardo en la posicion de memoria de los GPIO

      mov x15, #65536					   // cualquier numero para delay
	  lsl x15, x15, 8
    delayverde:    	                       // hago que led verde este prendido cierto tiempo
		sub x15, x15, #1
    	cmp x15, #0
    	bne delayverde

	mov w21, #0x000                        // vuelvo el bit correspondiente a encender el led a 0
    str w21, [x20, 0]                      
  
  br X30


Ledrojo: 
     mov w21, #0x200						// pongo el bit 6 en 1, esto es 001000000
	 str w21, [x20, 0]                      //guardo en la posicion de memoria de los GPIO

      mov x15, #65536					   // cualquier numero para delay
	  lsl x15, x15, 10
    delayrojo:    	                       // hago que led verde este prendido cierto tiempo
		sub x15, x15, #1
    	cmp x15, #0
    	bne delayrojo

	mov w21, #0x000                        // vuelvo el bit correspondiente a encender el led a 0
    str w21, [x20, 0]                      
  
  br x30


LedAmbos: 
     mov w21, #0x240					  // pongo el bit 9 y 6 en 1, esto es 0010010000000
	 str w21, [x20, 0]                      //guardo en la posicion de memoria de los GPIO

      mov x15, #65536					   // cualquier numero para delay
	  lsl x15, x15, 10
    delayleds:    	                       // hago que led verde este prendido cierto tiempo
		sub x15, x15, #1
    	cmp x15, #0
    	bne delayleds

	mov w21, #0x000                        // vuelvo el bit correspondiente a encender el led a 0
    str w21, [x20, 0]                      
  
   br x30


