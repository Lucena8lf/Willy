
;=======================================================
; Plantillas e inicializacion de hechos

(deftemplate casilla "S2: Plantilla para celdas visitadas"
	(slot fil)
	(slot col)
)

(defrule iniciaPosicion "S2: Inicia coordenadas actuales de Willy"
	(declare (salience 100))
	(not (posicion $?))
	=>
	(assert (posicion 0 0))
	(assert (casilla (fil 0) (col 0)))
)

;=======================================================


;(defrule moveWilly ;Quitar regla!!!
;   (directions $? ?direction $?)

;   ?m <- (nMov ?t&:(< ?t 999))

;   ?h <- (hice ?)

;   (percepts)

   ;?p <- (posicion ?fil ?col)
;   =>
;   (moveWilly ?direction)

;   (retract ?m ?h)
; 	(assert (nMov (+ ?t 1)))

;   (assert (hice ?direction))

   ;Solo sumamos
   ;(retract ?p)
   ;(assert (posicion (+ ?fil 1) (+ ?col 1)))
;   )

;(defrule fireWilly ; Regla antigua!!!
;	(hasLaser)
;	(directions $? ?direction $?)
;	(percepts $? Noise $?)

;	?m <- (nMov ?t&:(< ?t 999))
;	=>
;	(fireLaser ?direction)

;	(retract ?m)
;  	(assert (nMov (+ ?t 1)))
;	)

(defrule iniciar-movimientos
	(not (nMov ?) )
	=>
	(assert (nMov 0) )
)

(defrule iniciar-hice
	(not (hice ?) )
	=>
	(assert (hice nada) )
)

(defrule volver-norte
	(declare (salience 100))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts ? $?)

	?h <- (hice north)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly south)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice south))

   	; Actualizamos posicion (se mueve hacia el sur, sumamos 1 a la fila)
   	(retract ?p)
   	(assert (posicion (+ ?fil 1) ?col))
   	; Actualizamos casillas visitadas
   	(assert (casilla (fil ?fil) (col ?col)))

)

(defrule volver-sur
	(declare (salience 100))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts ? $?)

	?h <- (hice south)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly north)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice north))

   	; Actualizamos posicion (se mueve hacia el norte, restamos 1 a la fila)
   	(retract ?p)
   	(assert (posicion (- ?fil 1) ?col))

)

(defrule volver-este
	(declare (salience 100))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts ? $?)

	?h <- (hice east)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly west)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice west))

   	; Actualizamos posicion (se mueve hacia el oeste (izquierda), restamos 1 a la columna)
   	(retract ?p)
   	(assert (posicion ?fil (- ?col 1)))

)

(defrule volver-oeste
	(declare (salience 100))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts ? $?)

	?h <- (hice west)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly east)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice east))

   	; Actualizamos posicion (se mueve hacia el este, sumamos 1 a la columna)
   	(retract ?p)
   	(assert (posicion ?fil (+ ?col 1)))

)

;=======================================================

; S2: Mover a Willy a una celda no visitada si no hay peligros

(defrule moverNorthWilly
	(declare (salience 50))

	(directions $? north $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)
	(not (casilla (fil ?f&:(= ?f (- ?fil 1))) (col ?col))) ;Si la celda mas al norte no esta visitada
	=>
	(moveWilly north)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice north))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion (- ?fil 1) ?col))
	(assert (casilla (fil (- ?fil 1)) (col ?col)))
)

(defrule moveSouthWilly
	(declare (salience 50))

	(directions $? south $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)
	(not (casilla (fil ?f&:(= ?f (+ ?fil 1))) (col ?col))) ;Si la celda mas al sur no esta visitada

	=>
	(moveWilly south)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice south))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion (+ ?fil 1) ?col))
	(assert (casilla (fil (+ ?fil 1)) (col ?col)))
)

(defrule moveEastWilly "Mover derecha"
	(declare (salience 50))

	(directions $? east $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)

	(not (casilla (fil ?fil) (col ?c&:(= ?c (+ ?col 1))))) ;Si la celda mas al este no esta visitada
	=>
	(moveWilly east)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice east))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion ?fil (+ ?col 1)))
	(assert (casilla (fil ?fil) (col (+ ?col 1))))
)

(defrule moveWestWilly "Mover izquierda"
	(declare (salience 50))

	(directions $? west $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)

	(not (casilla (fil ?fil) (col ?c&:(= ?c (- ?col 1))))) ;Si la celda mas al oeste no esta visitada

	=>
	(moveWilly west)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice west))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion ?fil (- ?col 1)))
	(assert (casilla (fil ?fil) (col (- ?col 1))))
)

;=======================================================

; S2: Mover a Willy a una celda ya visitada

(defrule moveNorthWillyAgain
	(declare (salience 10))

	(directions $? north $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)
	(casilla (fil ?f&:(= ?f (- ?fil 1))) (col ?col)) ;La casilla al norte ya esta visitada

	=>
	(moveWilly north)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice north))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion (- ?fil 1) ?col))
	(assert (casilla (fil (- ?fil 1)) (col ?col)))
)

(defrule moveSouthWillyAgain
	(declare (salience 10))

	(directions $? south $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)
	(casilla (fil ?f&:(= ?f (+ ?fil 1))) (col ?col)) ;La casilla al sur ya esta visitada

	=>
	(moveWilly south)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice south))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion (+ ?fil 1) ?col))
	(assert (casilla (fil (+ ?fil 1)) (col ?col)))
)

(defrule moveEastWillyAgain "Mover derecha"
	(declare (salience 10))

	(directions $? east $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)

	(casilla (fil ?fil) (col ?c&:(= ?c (+ ?col 1)))) ;La casilla al este ya esta visitada
	=>
	(moveWilly east)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice east))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion ?fil (+ ?col 1)))
	(assert (casilla (fil ?fil) (col (+ ?col 1))))
)

(defrule moveWestWillyAgain "Mover izquierda"
	(declare (salience 10))

	(directions $? west $?)

   	?m <- (nMov ?t&:(< ?t 999))

   	?h <- (hice ?)

	?p <- (posicion ?fil ?col)
	(percepts)

	(casilla (fil ?fil) (col ?c&:(= ?c (- ?col 1)))) ;La casilla al oeste ya esta visitada

	=>
	(moveWilly west)

	(retract ?m ?h)
 	(assert (nMov (+ ?t 1)))

   	(assert (hice west))

	; Actualizamos posicion y casillas visitadas
	(retract ?p)
	(assert (posicion ?fil (- ?col 1)))
	(assert (casilla (fil ?fil) (col (- ?col 1))))
)

; Lo unico que cambia es la prioridad de las reglas y eliminar el 'not'???

;====================================================
; * Apuntar ruidos encontrados *
;
; Crear reglas como las de volver hacia atrÃ¡s al encontrar un peligro,
;   pero Ãºnicamente si encuentra ruido (tendrÃ¡ mayor prioridad que las de
;   retroceder genÃ©ricas)
; Hacer lo mismo (retroceder), pero apuntar en un hecho en quÃ© posiciÃ³n 
;   ha encontrado el ruido
;
; Por ejemplo, crear un hecho que sea (hay-ruido 3 2), indicando que el ruido
;   estÃ¡ en la fila 3 y columna 2.
;
; Al igual que para retroceder ante peligros, serÃ¡n un total de 4 reglas
;   (Las reglas de retroceder ante peligro cualquiera sigue existiendo,
;    pero con menor prioridad)

(defrule retroceder-ruido-norte
	(declare (salience 110))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts Noise)

	?h <- (hice north)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly south)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice south))

   	;Creamos un hecho que tendra la posicion en la que hemos encontrado el ruido
   	(assert (hay-ruido ?fil ?col))

   	; Actualizamos posicion (se mueve hacia el sur, sumamos 1 a la fila)
   	(retract ?p)
   	(assert (posicion (+ ?fil 1) ?col))
)

(defrule retroceder-ruido-sur
	(declare (salience 110))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts Noise)

	?h <- (hice south)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly north)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice north))

   	;Creamos un hecho que tendra la posicion en la que hemos encontrado el ruido
   	(assert (hay-ruido ?fil ?col))

   	; Actualizamos posicion (se mueve hacia el norte, restamos 1 a la fila)
   	(retract ?p)
   	(assert (posicion (- ?fil 1) ?col))
)

(defrule retroceder-ruido-este
	(declare (salience 110))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts Noise)

	?h <- (hice east)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly west)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice west))

   	;Creamos un hecho que tendra la posicion en la que hemos encontrado el ruido
   	(assert (hay-ruido ?fil ?col))

   	; Actualizamos posicion (se mueve hacia el oeste, restamos 1 a la columna)
   	(retract ?p)
   	(assert (posicion ?fil (- ?col 1)))
)


(defrule retroceder-ruido-oeste
	(declare (salience 110))

	?m <- (nMov ?t&:(< ?t 999))

	(percepts Noise)

	?h <- (hice west)

	?p <- (posicion ?fil ?col)
	=>
	(moveWilly east)

	(retract ?m ?h)
   	(assert (nMov (+ ?t 1)))
   	(assert (hice east))

   	;Creamos un hecho que tendra la posicion en la que hemos encontrado el ruido
   	(assert (hay-ruido ?fil ?col))

   	; Actualizamos posicion (se mueve hacia el este, sumamos 1 a la columna)
   	(retract ?p)
   	(assert (posicion ?fil (+ ?col 1)))
)


;====================================================
; * Disparar si volvemos a encontrar un ruido en la misma fila/columna *
;
; HabrÃ¡ 4 reglas distintas dependiendo de a dÃ³nde haya que disparar
;
; Si teniamos alguna regla anterior para disparar al alien, habrÃ¡ que eliminarla

(defrule fireAlienNorth "Si detecto un ruido y habia otro mas arriba, disparar hacia el norte para matar al alien"
	(declare (salience 120))

	?hm <- (nMov ?t&:(< ?t 999))
	?hp <- (posicion ?fil ?col)
	(directions $? north $?)

	(percepts $? Noise $?) ; Se detecta, al menos, un ruido
	(hay-ruido ?filInferior&:(< ?filInferior ?fil) ?col) ; Ya habia un ruido mas arriba de la posicion actual
	(hasLaser)
	=>
	(retract ?hm)
	(assert (nMov (+ ?t 1)))

	(fireLaser north) ; Disparamos al oeste

	; Apuntar, para que quede registro, que tambien se escucho ruido en esta celda
	(assert (hay-ruido ?fil ?col))
)

(defrule fireAlienSouth "Si detecto un ruido y habia otro mas abajo, disparar hacia el sur para matar al alien"
	(declare (salience 120))

	?hm <- (nMov ?t&:(< ?t 999))
	?hp <- (posicion ?fil ?col)
	(directions $? south $?)

	(percepts $? Noise $?) ; Se detecta, al menos, un ruido
	(hay-ruido ?filSuperior&:(> ?filSuperior ?fil) ?col) ; Ya habia un ruido mas arriba de la posicion actual
	(hasLaser)
	=>
	(retract ?hm)
	(assert (nMov (+ ?t 1)))

	(fireLaser south) ; Disparamos al oeste

	; Apuntar, para que quede registro, que tambien se escucho ruido en esta celda
	(assert (hay-ruido ?fil ?col))
)

(defrule fireAlienEast "Si detecto un ruido y habia otro mas a la derecha, disparar hacia el este para matar al alien"
	(declare (salience 120))

	?hm <- (nMov ?t&:(< ?t 999))
	?hp <- (posicion ?fil ?col)
	(directions $? east $?)

	(percepts $? Noise $?) ; Se detecta, al menos, un ruido
	(hay-ruido ?fil ?colDcha&:(> ?colDcha ?col)) ; Ya habia un ruido mas a la derecha de la posicion actual
	(hasLaser)
	=>
	(retract ?hm)
	(assert (nMov (+ ?t 1)))

	(fireLaser east) ; Disparamos al oeste

	; Apuntar, para que quede registro, que tambien se escucho ruido en esta celda
	(assert (hay-ruido ?fil ?col))
)

(defrule fireAlienWest "Si detecto un ruido y habia otro mas a la izquierda, disparar hacia el oeste para matar al alien"
	(declare (salience 120))

	?hm <- (nMov ?t&:(< ?t 999))
	?hp <- (posicion ?fil ?col)
	(directions $? west $?)

	(percepts $? Noise $?) ; Se detecta, al menos, un ruido
	(hay-ruido ?fil ?colIzq&:(< ?colIzq ?col)) ; Ya habia un ruido mas a la izquierda de la posicion actual
	(hasLaser)
	=>
	(retract ?hm)
	(assert (nMov (+ ?t 1)))

	(fireLaser west) ; Disparamos al oeste

	; Apuntar, para que quede registro, que tambien se escucho ruido en esta celda
	(assert (hay-ruido ?fil ?col))
)