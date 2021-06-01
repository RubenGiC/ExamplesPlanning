(define (problem star_craft_prob2)
	(:domain star_craft2)
	(:objects
		loc11 loc12 loc13 loc14 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 - localizacion
		cent_mand1 - edificio
		vce1 vce2 - unidad
		rec1 rec2 rec3 - recurso
	)
	(:init
		;inicializo las conexiones de las localizaciones
		(camino loc11 loc12)
		(camino loc11 loc21)
		(camino loc12 loc22)
		(camino loc13 loc14)
		(camino loc13 loc23)
		(camino loc14 loc24)

		(camino loc21 loc31)
		(camino loc22 loc32)
		(camino loc23 loc22)
		(camino loc24 loc34)

		(camino loc31 loc32)
		(camino loc33 loc34)

		;el centro de comando 1 se encuentra en la localización 11
		(construido cent_mand1)

		;El tipo de edificio es CentroDeMando
		(edificios cent_mand1 centro_de_mando)

		;y las unidades tambien se encuentra en esa misma localizacion
		(en vce1 loc11)
		(en vce2 loc11)

		;las unidades esta libre
		(libre vce1)
		(libre vce2)

		;las unidades son de tipo vce
		(unidades vce1 vce)
		(unidades vce2 vce)

		;los recursos se encuentra en las localizaciones
		(hay rec1 loc23)
		(hay rec2 loc33)
		(hay rec3 loc13)

		;y ambos recursos son de tipo mineral
		(recursos rec1 mineral)
		(recursos rec2 mineral)
	)
	(:goal
		(and
			(or 
				(extrayendo rec1)
				(extrayendo rec2)
			)
		)
	)
)