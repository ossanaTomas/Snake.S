//--------DEFINICIÓN DE FUNCIONES-----------//
    .global inputRead    
	//DESCRIPCION: Lee el boton en el GPIO17. 
//------FIN DEFINICION DE FUNCIONES-------//





// Tengo: 
// PERIPHERAL_BASE, 0x3F000000  base de los perisfericos
// GPIO base = 0x200000         base de los gpios entiendo que seria igual al primero de estos
// en el codigo que nos dieron tenemos que en w20 guardan PERIFERIAL_BASE + GPIO_BASE 	
// Esta suma es igual a 0x3F200000 = 8*4 = 32 bits 1word. 
// podemos establecer directamente que la suma de estas dos cosas es la base de los perisfericos
// luego, una vez que tenemos la base de los perisfericos lo que es nesesario es seleccionar un conjunto de 10 pines
// esto se hace con los GPFSEL(X) si x es 0 selecciono pines de 0-9 si x es 1 selecciono pines de (10-19) y haci hasta x=5
// esto lo hacemos en app, la base de los gpio anteriores con un ofset y con esto estoy en la direccion de memoria del conjunto de pines
// para configurar un pin como entrada nesesito establercer con (000) los bits correspondintes de GPSEL 
// ahora con GPLEV veo el nivel de los gpios si en bit n esta en 1 o 0 corresponde directamente a al estado del pin n 
// con GPSET establezco 

// para nuestro caso
//GPIO 14 = Arriba
//GPIO 17= derecha
//GPIO 15= izquierda
//GPIO 18= abajo, pero en el caso de la serpiente este no tiene sentido podria ser otra implementacion
// los siguientes tienen que ser de escritura
//GPIO 2= led verde 
//GPIO 3= led rojo



//funcion para leer eventos: 
// una sola funcion lee todo, podria ser desarmada en funciones individuales tmb.
inputRead: 	
	ldr w22, [x20, GPIO_GPLEV0] 	//base + lev0 (selecciona 32 bits) Leo el registro GPIO Pin Level 0 y lo guardo en X22
	and X22,X22, 0x20000	// Limpio el bit 17 (estado del GPIO17)--DERECHA
	and X23,x22, #0x8000     // bit 16 en 1, --IZQUIERDA
    And x24,x22, #0x4000     // bit15 en 1--	ARRIBA
	And x25,x22, #0x40000    //bit 19 en 1-- ABAJO (Sin sentido por ahora)
		
    br x30 		//Vuelvo a la instruccion link

