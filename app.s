
// SNAKE

// definimos que nuestra pantalla va a contar con una cuadricula de 16x16 rectangulos con 
// cada cuadrado dentro de la cuadricula de 32X32 bits. 

.equ Pantalla, 512 // tamaño de la pantalla,
.equ SQUARE, 32    // defino la cantidad de pixeles que tiene un cuadrado en mi cuadricula. 
.equ MaxCuadricula, 15
.equ MinCuadricula, 0


.globl app
app:
	//---------------- Inicialización GPIO --------------------

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO.		
	
	
	// Configurar GPIO 17 como input:
	mov X21,#0
	str w21,[x20,GPIO_GPFSEL1] 		// Coloco 0 en Function Select 1 (base + 4)   	
	
	//---------------- Main code --------------------

	// x0--> Direccion Base del Framebuffer (NO MODIFICAR)
	// vamos a mover tambienn la base del framebuffer a x10, y usar este
        mov x10, x0
//X1-->Indice columnas=X
//x2-->Indice filas=Y
// x3--> Temporal para Posicion Y
// x4  -> Temporal para Posicion x
//x0-x7 argumentos-resutados
//x8 resultados indirectos
//x9-x15 temporales



     

        mov x5,#8

        MOV x1, x5	           // indice de columnas=X.  
		MOV x2, #3             // indice de filas= Y 
		MOV w4, #0x56df        // ACA MODIFICO COLOR
		MOV x10, x0             // Frame buffer=A
		MOV x11, Pantalla      // N=Numero de pixeles- NO SE MODIFICA
        Bl  cuadrado


	


        mov x4, 0
	movimiento: 	
	// --- Delay loop ---
	movz x11, 0x20, lsl #16
delay1: 
	sub x11,x11,#1
	cbnz x11, delay1
	// --- End Delay loop ---
        MOV x1, 7	  
        MOV x2, x4             // indice de filas= Y 
		MOV w4, #0x56df        // ACA MODIFICO COLOR
		MOV x10, x0             // Frame buffer=A
		MOV x11, Pantalla 
        Bl  cuadrado

        add x4, x4, #3
	    cmp x4, #15
	    b.le movimiento



	


InfLoop: 
	b InfLoop
		
	