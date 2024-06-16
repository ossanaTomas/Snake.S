.globl app
app:
	//---------------- Inicialización GPIO --------------------
	//Correeponde a  ininciacion y teclas 

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO. x|x|iniciacion		
	
	// Configurar GPIO 17 como input:
	mov X21,#0
	str w21,[x20,GPIO_GPFSEL1] 		// almaceno-pongo 0 en la direccion base+ gpiosel1, con esto aparte de configurar
	// el gpio17 como imput, estoy poniedo todo el resto de sel1 en 0, con lo cual ya todos (10-19) me quedan configurados
	//como imput. Siendo mas riguroso esto no es del todo correcto dado que configuro mas pines, pero me sirve dado que 
	// selecciono como entradas todos lo pines que voy a utilizar. 
	
	//configurar GPIO 1 y 3 como Ouput: 
     mov x26, #0x000           //nesesito un 1 en la posicion 6 y en la 9
	stur w26,[x20,#0]        //gpio sel0 es lo mismo que ofset de 0 desde la direccion base
                             //guarde en la posicion de memoria, que estos bits estan en 1. 




	// X0 contiene la dirección base del framebuffer (NO MODIFICAR, JAMAS MODIFICAR ES EL PRIMER BITS)
	//Conivene tomarlo como referenica y movernos por medios de otros registros como en X10
	//---------------- Main code --------------------

   // mov x15, #0x240
   // str w15, [x20, 0]

    // mov x27, #0x40
	//str w27, [x20, 0]


	// mov x27, #0x200
	//str w27, [x20, 0]









//x1 contine el framebuffer

//------------------------------------------------------LA TIERRA---------------------------------------------------------------------
/*

MOV X9, #0 //POCISIONE EJE Y LA ULTIMA FILA 
MOV X2, #16   //CONTADOR DE FILAS RESTA EN Y
MOV W4, 0x07E0  //DIFINO W4 COMO UN COLOR VERDE DE INICIO PARA QUE TENGA CON QUE COMPARAR 
MOV W5,0x7BE0  //GUARDO EL VERDE OLIVA PARA HACER LUEGO LA COMPARACION 
MOV W6,0x07E0  // GUARDO EL VERDE CLARO PARA HACER LUEGO LA COMPARACION  


TRES_SEIS:
MOV X3,#16       //CONTADOR DE PARA HACER LOS 8 CUADRADOS
MOV X12, #0     //POCISIONE EJE X IGUAL 0 PRIMERA COLUMNA


		green_paece:

		//Comparo en que verde estoy para saltar al proximo
		CMP W4, W5
		BEQ verde_claro

		CMP W4, W6
		BEQ verde_oliva

				verde_oliva:
					MOV x1, x0             // x1 contiene la dirección base del frame buffer = A
					MOV w4, 0x7BE0      // Modifico color
					MOV x11, #512          // N = Número de píxeles - NO SE MODIFICA

					MOV x15, #32           // Alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
					MOV x14, #32           // Hasta donde iterar en X = x14  ACA MODIFICO ANCHO
					ADD x12, x12, XZR           // Inicio de la primera columna
					MOV X13, X9         // Inicio de la fila postSerpiente (Y constante)
						BL cuadrado         // Llamo a la función cuadrado

				cbz xzr, continue    //COMPARO CON ZERO PARA SALTAR DIRECTO A CONTINUE



				verde_claro:
					MOV x1, x0             // x1 contiene la dirección base del frame buffer = A
					MOV w4,  0x07E0       // Modifico color
					MOV x11, #512          // N = Número de píxeles - NO SE MODIFICA

					MOV x15, #32           // Alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
					MOV x14, #32           // Hasta donde iterar en X = x14  ACA MODIFICO ANCHO
					ADD x12, x12, XZR    // Pasamos a la proxima pocision
					MOV X13, X9          // Inicio de la fila postSerpiente (Y constante)
						BL cuadrado         // Llamo a la función cuadrado	
				cbz xzr, continue			//COMPARO CON ZERO PARA SALTAR DIRECTO A CONTINUE


		continue:
		ADD X12, X12, #32 //SUMO 64 PASO A PRIXIMO ELEMENTO DEL EJE X
		sub x3,x3,#1        //decremento EL CONTADOR 
		cbnz x3, green_paece  //JUMP


ADD X9, X9 ,#32 //RESTO 64 EN EJE Y,  PASO ANTERIOR FILA
SUB X2, X2, #1 // DISMINUTO EL CONTADOR 

	//Comparo en que verde estoy para saltar al proximo
		CMP W4, W5
		BEQ verde_claro_2

		CMP W4, W6
		BEQ verde_oliva_2

verde_claro_2: MOV W4, 0x07E0 
CBZ XZR, continue_2

verde_oliva_2: MOV w4, 0x7BE0 
cbz xzr, continue_2

continue_2:
cbnz X2, TRES_SEIS  
*/



	//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x7BE0         // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512         // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
		



//----------------------------------------------------- Limites donde no pisar -----------------------------------------------------------------------



	//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x56df           // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #32          // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
	


		//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x56df           // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #480           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #32          // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 

		
		
			//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x56df           // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #1        // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #31          // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512          // hasta donde iterar en X = x14  ACA MODIFICO ANCHO


				//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x56df           // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #480         // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #32           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512          // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 



//----------------------------------------------------- Variable  -----------------------------------------------------------------------

//SETEO VARIABLES 

	MOV X2, #224
	MOV X3, #224
	MOV X6, #224  //Para anterior X
	MOV X5, #224 //Para anerior x



mover_cuadrado:

	//Comparo si estoy fuera del mapa limite derecha
		CMP X2, 480
		BEQ FIN_JUEGO



	// --- Delay loop ---
	movz x11, 0x20, lsl #16
delay1: 
	sub x11,x11,#1
	cbnz x11, delay1
	// --- End Delay loop ---


				
	//Pinto pixel anterior 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x7BE0         // ACA MODIFICO COLOR      // ACA MODIFICO COLOR
		MOV x11, #512          // NO SE MODIFICA
		MOV x12, X6	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, X3          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #32           //ACA MODIFICA ALTO
		MOV x14, #32          // ACA MODIFICO ANCHO
		BL cuadrado            // llamo a la funcion cuadrado. 





	//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0xFFFF        // ACA MODIFICO COLOR
		MOV x11, #512          // NO SE MODIFICA
		MOV x12, X2	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, X3          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #32           //ACA MODIFICA ALTO
		MOV x14, #32          // ACA MODIFICO ANCHO
		BL cuadrado            // llamo a la funcion cuadrado. 

		
//chekear movimientos: 		
		
	    //Movimieto a Derecha
		bl inputRead
      
	  
	  //altar a ir hacia arriba
	    sub x14, x24, #0x4000    //comparo x24 con el bit que deberia estar encendido, si esta 
		cbz x14 ,               // salto a algun lugar en donde este la implemetacion para ir hacia arriba. 

	  

		ADD X2, X2 , #32 //X2=X2+32 paso a proximo elemento derecha 
		SUB X6, X2 , #32 //X2= (X2+32)-32

	

		
		
CBZ XZR, mover_cuadrado


//---------------------------------------------------------Manzana----------------------------------------------------------------



//MANZANA:
//llamamos a dibujar circulo con estos parametros
    MOV x1, x0
    MOV x18, #450       // centroX
    MOV x19, #285       // centroY
    MOV x2, #35         // radio
    MOV x20, #512       // (Número de columnas)No modificar. 
    mov w15, #0xf800        //Puca correria 

    BL dibujar_circulo



//BRILLO EN LA MANZANA
//llamamos a dibujar circulo con estos parametros
    MOV x1, x0
    MOV x18, #465       // centroX
    MOV x19, #275       // centroY
    MOV x2,  #6       // radio
    MOV x20, #512       // (Número de columnas)No modificar. 
    mov w15, #0xfc6f   // Pink 

    BL dibujar_circulo


//TALLO DE LA MANZANA 
	//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x40E3           // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #450	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #245          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #10           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #4          // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
		

	//Una hoja 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, 0x07E0            // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #452	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #245          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #4           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #12          // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
		

//-------------------------------------------------------Infinity loop---------------------------------------------------------------------------

FIN_JUEGO:
	//llamamos a dibujar cuadrado con estos parametros: 
		MOV x1, x0  // x1 contiene la direccion base del frame buffer= A
		MOV w4, #0x40E3       // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512         // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
        BL Ledrojo

InfLoop: 
	b InfLoop  
