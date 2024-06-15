.global cuadrado
	//genera un cuadrado o rectangulo a partir de cordenas x-y color
    // cordenadas de 0 a 15 tanto en X como en Y
	
.global dibujar_circulo
   // genera un circulo pasando def de  radio, centro(x,y) y color
	
.global dibujar_triangulo	
	// dibuja un triangulo en la posicion que le pasamos.  
	
// deberia limpiar x16

//-------------------------------------------cuadrado--------------------------------------------------------------
cuadrado: 
// multiplico las variables indices por 16 para pintar el cuadrado espesifico. 
        lsl x1, x1, #5  //x= x*32 
		lsl x2,x2, #5   //Y=y*32
        MOV x13, 0     // contador de filas. 

Loop_filasY:
    MOV x14, x1                  // Restaurar valor inicial de X-columna para cada nueva fila
    MOV x12, 0

    Loop_columnasX:
        // Calcular dirección para pintar
        MUL x15, x2, x11                // x16 = Y * N
        ADD x15, x15, x14        	    // x16 = (y * n) + X
        LSL x15, x15, #1        	    // x16 = 2 * ((Y * n) + X)
        ADD x15, x15, x10        	    // x16 = A + 2 * (Y * n + X)
        STURH w4, [x15, #0]      	    // Pintar la posición X16
        
        ADD x14, x14, #1    			// Incrementar índice de columna -> siguiente x
		Add x12,x12, 1    			    // Sumamos uno a contador de columna
	    cmp x12, SQUARE                 // comrobamos si hemos llegado a los 32 pix. 
        b.ne  Loop_columnasX            // Si no, sigo pintando    
           


    ADD x2, x2, #1                       // Incrementar índice de fila -> siguiente Y
	ADD x13,x13, #1	                     // sumamos uno al contador de columnas
    cmp x13, SQUARE             // Comprobar si hemos alcanzado el final del alto del cuadrado
    B.eq  Fin_Cuadrado         // Si alcanzamos el alto, fin cuadrado.
    B Loop_filasY

Fin_Cuadrado:

 BR x30 

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
				BGE skip_pixel      //  si x13, > r^2 , salta, sino, pinta el pixel

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


//-----------------------------------------TRIANGULO----------------------------------------------------------------------------------------------------
dibujar_triangulo: 

    // x1: iniciox
    // x2: inicioY
    // x3: color
    // x5: base (cateto mayor)
    // x6: altura (cateto menor)

    // Inicializa el contador de líneas (y)
    mov x4, 0

draw_triangle_y_loop:
    cmp x4, x6           // llegamos a la altura espesifica 
    bge draw_triangle_done

    // Calcula el ancho de la línea actual
    mul x9, x4, x5       // x9 = y * base / altura
    sdiv x9, x9, x6      // x9 = (y * base) / altura

    // Calcular la dirección inicial del píxel
    add x10, x2, x4      // x10 = start_y + y
    mov x11, 512         //  tam pantalla
    mul x10, x10, x11    // x10 = (start_y + y) * cant columnas
    add x10, x10, x1     // x10 += start_x
    add x10, x10, x5     // x10 += base
    sub x10, x10, x9     // x10 -= current_width (alinear a la derecha)
    lsl x10, x10, 1      // x10 *= 2 
    add x12, x0, x10     // x12 = framebuferbase+ offset

    // Bucle interno para dibujar una línea del triángulo
draw_triangle_x_loop:
    cmp x9, 0            // ¿Hemos dibujado todos los píxeles en esta línea?
    beq draw_triangle_next_line

    strh w3, [x12]       // Dibujar píxel
    add x12, x12, 2      // Mover al siguiente píxel
    sub x9, x9, 1        // Decrementa el contador de ancho
    b draw_triangle_x_loop

draw_triangle_next_line:
    add x4, x4, 1        // Incrementa el contador de líneas (y)
    b draw_triangle_y_loop

draw_triangle_done:
  
  BR X30
//--------------------------------------------------------------------------------------------------------------------//
