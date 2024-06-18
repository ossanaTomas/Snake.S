



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
     mov x26, #0x000          //nesesito un 1 en la posicion 6 y en la 9
	stur w26,[x20,#0]        //gpio sel0 es lo mismo que ofset de 0 desde la direccion base
                             //guarde en la posicion de memoria, que estos bits estan en 1. 




	// X0 contiene la dirección base del framebuffer (NO MODIFICAR, JAMAS MODIFICAR ES EL PRIMER BITS)
	//Conivene tomarlo como referenica y movernos por medios de otros registros como en X10
	//---------------- Main code --------------------

   // mov x15, #0x240
   // str w15, [x20, 0]









//------------------------------------------------------Pantalla de inicio----------------------------------------------------------------

	//llamamos a dibujar cuadrado con estos parametros: 
	
		MOV w4, #0xd970      // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512         // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
		BL cuadrado            // llamo a la funcion cuadrado. 
		
MOV X6, #3
MOV X2, #450
MOV X3, #285
	espera_pantalla_inicio:

		// --- Delay loop ---
		movz x11, 0x20, lsl #16
		delayini: 
		sub x11,x11,#1
		cbnz x11, delayini
		// --- End Delay loop ---


SUB X6, X6, #1
CBZ X6, espera_pantalla_inicio
 BL LedAmbos
 BL LedAmbos


//------------------------------------------------------LA TIERRA---------------------------------------------------------------------
	//llamamos a dibujar cuadrado con estos parametros: 
		  
		MOV w4, #0x7BE0         // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512         // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
		

//llamamos a funcion random: }


GenerateAgain: 

bl generateRandomPosition

 // esto es como una condicion And
 //si ambos son 256 nesesito otro numeoro dado que es la posicion inicial de la snake
 // con que alguno sea diferente, la posicion ya es valida.
    cmp x18, #256    
	b.NE Falsecondition    
	cmp x19, #256   
	b.EQ GenerateAgain
Falsecondition: 


    // Los resultados en píxeles están en x18 y x19
    // x18 contiene la posición X en píxeles
    // x19 contiene la posición Y en píxeeles


//  MANZANA inicial:
//llamamos a dibujar circulo con estos parametros
 
	MOV x11, #512       // (Numero de columnas)No modificar.
	//COMENTADO POR QUE TOMO EL RESULTADO DE LA SALIDA DE LO ALEATORIO
   // MOV x18, #256       // centroX deberia tener la salida de la funcion anterior:
   // MOV x19, #160       // centroY deberia tener la salida de la funcion anterior: 
    MOV x2, #15        // radio
    mov w15, #0xf800         
    BL dibujar_circulo

//----------------------------------------------------- Limites donde no pisar -----------------------------------------------------------------------

	//Limite de Izquierdo X=0 Y=0 ancho 32 alto 512
	
		MOV w4, #0x56df           // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           
		MOV x13, #0          
		MOV x15, #512           
		MOV x14, #32          
		BL cuadrado            

	//Lmite Izquierdo X=480 Y=0
		
		MOV w4, #0x56df           // ACA MODIFICO COLOR
		MOV x11, #512          
		MOV x12, #480          
		MOV x13, #0          
		MOV x15, #512           
		MOV x14, #32         
		BL cuadrado            

		
	//Limite Superior X=0 y Y=0 alto 32 y ancho 512
		
		MOV w4, #0x56df           
		MOV x11, #512         
		MOV x12, #0           
		MOV x13, #0        
		MOV x15, #32          
		MOV x14, #512          
		BL cuadrado             


	//Limite Inferior X=0 y Y=480
		
		MOV w4, #0x56df          
		MOV x11, #512          
		MOV x12, #0           
		MOV x13, #480         
		MOV x15, #32           
		MOV x14, #512          
		BL cuadrado            

//----------------------------------------------------- Variable  -----------------------------------------------------------------------

//SETEO VARIABLES 

/*
  X2---> Mueve la pocision de aparacion del cuadrad en X correspondiente a movimientos derecha e izquierda
  X3---> Mueve la pocision de aparacion del cuadrado en Y correspondiente a los movimietos arriba y abajo
  
  X6---> Guarda la pocision del pixel anterior en X correspondiente a la casilla anterior derecha e izquierda 
  X5---> Guarda la pocision del pixel anererior en Y correspondiente a la casilla aneterior de arriba y abajo
  */

	MOV X2, #256
	MOV X3, #256

	MOV X6, #256  //Para anterior X
	MOV X5, #256 //Para anerior x

	MOV X7, #0 //registro de guarado GPIO anterior 






//Loop del juego:
mover_cuadrado:



//ACA ESTA LO QUE NO ESTA FUNCIONANDO, COMPARA SI ESTA SOBRE LA MANZANA
// PODRIA PENSAR EN IMPLEMENTARLO COMPARANDO COLORES DE FORNDO

    	//Comparar si comio manzana esto se va dar si tanto las posiciones en 
	  // x como en Y de la snake son iguales a la Apple: 
	
	 
	  

	    cmp x2,x18
		B.ne Nocome
		cmp x3,x19
		b.eq Come
        b Nocome
//  esto da error la comprovacion de comer
Come: 
 
     
    //	MOV x11, #512       // (Numero de columnas)No modificar.
	//COMENTADO POR QUE TOMO EL RESULTADO DE LA SALIDA DE LO ALEATORIO
   // MOV x18, #256       // centroX deberia tener la salida de la funcion anterior:
   // MOV x19, #160       // centroY deberia tener la salida de la funcion anterior: 
  //   MOV x2, #15        // radio

  //sOLO DESCOMENTAR LAS SIGUJIENTES LINEAS PARA LA LLAMADA AL CIRCULO: 
    bl Ledverde
    bL generateRandomPosition
    mov w15, #0xf800 
    bL dibujar_circulo

Nocome: 
      

	//Los limite de  derecha e izquieda se comparan con registro X2
	//Comparo si estoy fuera del mapa limite derecha
		CMP X2, #480
		BGE FIN_JUEGO

	//Comparo si estoy fuera del mapa limite Izquierdo
		CMP X2,#32
		BLT FIN_JUEGO


	//Los limite de arriba y abajo se comparan con registro X3
		//Comparo si estoy fuera del mapa limite abajo
		CMP X3, #480
		BGE FIN_JUEGO

	//Comparo si estoy fuera del mapa limite arriba 
		CMP X3,#32
		BLT FIN_JUEGO
        
  
		

	// --- Delay loop ---
	movz x11, 0x1A, lsl #16
	delay1: 
	sub x11,x11,#1
	cbnz x11, delay1
	// --- End Delay loop ---


				
	//Pinto pixel anterior 
	
		MOV w4, #0x7BE0         // ACA MODIFICO COLOR      // ACA MODIFICO COLOR
		MOV x11, #512          // NO SE MODIFICA
		MOV x12, X6	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, X5          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #32           //ACA MODIFICA ALTO
		MOV x14, #32          // ACA MODIFICO ANCHO
		BL cuadrado            // llamo a la funcion cuadrado. 





	//llamamos a dibujar cuadrado con estos parametros: 
	
		MOV w4, #0xFFFF        // ACA MODIFICO COLOR
		MOV x11, #512          // NO SE MODIFICA
		MOV x12, X2	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, X3          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #32           //ACA MODIFICA ALTO
		MOV x14, #32          // ACA MODIFICO ANCHO
		BL cuadrado            // llamo a la funcion cuadrado. 

		
//chekear movimientos: 		
		
	//Input Read
		BL inputRead
      
	//En el caso de que haya leido algo input Read
	   // a ir hacia derecha  
	    sub x14, x27, 0x20000               //comparo x24 con el bit que deberia estar encendido, si esta 
		cbz x14 , Derecha                   // salto a algun lugar en donde este la implemetacion para ir hacia arriba. 
		  //b noderecha

		// a ir hacia izquierda 
	    sub x14, x23, 0x8000                     //comparo x24 con el bit que deberia estar encendido, si esta 
		cbz x14 , IZQUIERDA             // salto a algun lugar en donde este la implemetacion para ir hacia arriba. 
		  //b noizquierda

		// a ir hacia arriba  
	    sub x14, x24, 0x4000        //comparo x24 con el bit que deberia estar encendido, si esta 
		cbz x14 , ARRIBA             // salto a algun lugar en donde este la implemetacion para ir hacia arriba. 
		  //b noderecha

		// a ir hacia derecha  
	    sub x14, x25, 0x40000   //comparo x24 con el bit que deberia estar encendido, si esta 
		cbz x14 , ABAJO             // salto a algun lugar en donde este la implemetacion para ir hacia arriba. 
		  
	// COMPARADORES EN CASO DE QUE EL INPUTREAD NO LEA NADA 
	//por ahora desactivado hasta que anden los otros movimientos 



      CMP X7, #6
	  BEQ Derecha

	  CMP X7, #4
	  BEQ IZQUIERDA

	  CMP X7, #8
	  BEQ ARRIBA

	  CMP X7, #2
	  BEQ ABAJO	
  
		b Ysalta  


Derecha: 
        cmp x7, #4               // si esta aciva la bandera de izquierda , esquivamos ir a la derecha
		b.eq IZQUIERDA          //  seguimos yendo a izquierda por mas que precionenen el pulsador. 
        SUB X6, X2 , #0
		SUB X5, x3, #0
		ADD X2, X2 , #32 //X2=X2+32 paso a proximo elemento derecha 
		MOV X7, #6
		b Ysalta 
		//noderecha: 
	

IZQUIERDA:
        cmp x7, #6               // si esta aciva la bandera de derecha, esquivamos ir a la izquierda. 
		b.eq Derecha             //seguimos ejecutando ir a la derecha. 
        SUB X5, x3, #0
		SUB X6, X2 , #0
		SUB X2, X2 , #32 //X2=X2-32 paso a proximo elemento IZUQIERDA 
		MOV X7, #4
		b Ysalta 
		          //noizquierda: 

ARRIBA:
         cmp x7, #2               // si esta aciva la bandera de abajo, esquivamos ir hacia arriba. 
		b.eq ABAJO                // seguimos ejecutando ir hacia abajo 
        SUB X6, X2 , #0
        ADD X5, X3, #0
		SUB X3, X3, #32
		MOV X7, #8
		b Ysalta 

ABAJO: 
        cmp x7, #8              // si esta aciva la bandera de arriba, esquivamos ir hacia abajo. 
		b.eq ARRIBA              // seguimos ejecutando ir hacia arriba. 
        SUB X6, X2 , #0
        SUB X5, X3, #0
		ADD X3, X3, #32
		MOV X7, #2

Ysalta:




CBZ XZR, mover_cuadrado





//-------------------------------------------------------fin juego---------------------------------------------------------------------------

FIN_JUEGO:
	  //llamamos a dibujar cuadrado con estos parametros: 
		
		MOV w4, #0xf800      // ACA MODIFICO COLOR
		MOV x11, #512          // N=Numero de pixeles- NO SE MODIFICA
		MOV x12, #0	           // indice de columnas = ACA MOFICA INICIO X
		MOV x13, #0          // indice de filas = ACA MODIFICA INICIO Y
		MOV x15, #512           // alto - hasta donde iterar en Y = x15  ACA MODIFICA ALTO
		MOV x14, #512         // hasta donde iterar en X = x14  ACA MODIFICO ANCHO
	
		BL cuadrado            // llamo a la funcion cuadrado. 
        BL Ledrojo   
		// cuando termino todo, si preciona alguna tecla, vuelve a jugar. 
		//Bl inputRead
		//cmp w22,0          //  
       // b.ne app
InfLoop: 
	b InfLoop  
