.global cuadrado
	//genera un cuadrado o rectangulo con un tam, pos y color
	
.global dibujar_circulo
   // genera un circulo pasando def de  radio, centro(x,y) y color
	
	
// deberia limpiar x16

//----------------------------------------------------------------------------------------------------------------------------------------------------
cuadrado: 

    Add x18,xzr,xzr     // x18=0
    Add x18,x14,#0     

	Loop_filasY:
		
		MOV x17, x12    // Restaurar valor inicial de X-columna para cada nueva fila
        MOV x14, x18   // ancho- Restaurar ancho del cuadrado para la siguiente fila  ACA MODICICA ANCHO
	
			Loop_columnasX:
			                            // Calcular direccion para pintar
					MUL x16, x11, x13    		// x16 = i * n
					ADD x16, x16, x17   	    // x16 = (i * n) + j
					LSL x16, x16, #1    		// x16 =  2* ((i * n) + j)
					ADD x16, x16, x1     		// x16 = A + 2 * (i * n + j)
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

//----------------------------------------------------------------------------------------------------------------------------------

dibujar_circulo:

    MUL x4, x2, x2      // calculamos radio^2 
    // recorer el cuadrado delimitador alrededor del circulo
    SUB x5, x18, x2     // inicioX = centroX - radio
    ADD x6, x18, x2     // endX = centroX + radio
    SUB x7, x19, x2     // inicioY = centroY - radio
    ADD x8, x19, x2     // endY = centroY + radio

    MOV x9, x7          // y = incioY

outer_loop:
		CMP x9, x8          // while (y <= endY)
		BGT end_outer_loop

		MOV x10, x5         // x = inicioX
		
			inner_loop:
				CMP x10, x6         // while (x <= endX)
				BGT end_inner_loop

    // Calculamos dx^2 y dy^2
				SUB x11, x10, x18   // dx = x - centroX
				MUL x11, x11, x11   // dx^2

				SUB x12, x9, x19    // dy = y - centroY
				MUL x12, x12, x12   // dy^2

			// Checkeamos si el punto (x, y) esta dentro del circulo
				ADD x13, x11, x12   // dx^2 + dy^2
				CMP x13, x4         // compare with radius^2
				BGT skip_pixel      //  si x13, > r^2 , salta, sino, pinta el pixel

				// Calculamos el pixel exacto a pintar, esto usa lo mismo que el cuadrado, podria ser otra funcion a la que se llama.
				MUL x14, x9, x20    // y * N
				ADD x14, x14, x10   // (y * N) + x
				LSL x14, x14, #1    // 2*(y * N) + x 
				ADD x14, x14, x1    // base address + offset=  A+ 2*(y * N) + x 
				
				STRH w15, [x14]     //pinta!!

				skip_pixel:
				ADD x10, x10, #1    // x++
				B inner_loop        

			end_inner_loop:
			
		ADD x9, x9, #1      // y++
	B outer_loop

end_outer_loop:
   
 
   br X30



//------------------------- Llamar a Puca---------------------------------
