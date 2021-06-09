(define (problem star_craft_prob3)
	(:domain star_craft3)
	(:objects
		loc11 loc12 loc13 loc14 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 - localizacion
		cent_mand1 extractor1 barracon1 - edificio
		vce1 vce2 vce3 - unidad
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

		;indicamos el tipo de edificio
		(edificios extractor1 extractor)
		(edificios barracon1 barracon)

		;inicializando tipo de recurso para construir
		(necesita extractor mineral)
		(necesita barracon mineral)
		(necesita barracon gas)

		;las unidades son de tipo vce
		(unidades vce1 vce)
		(unidades vce2 vce)
		(unidades vce3 vce)

		;y ambos recursos son de tipo mineral
		(recursos rec1 mineral)
		(recursos rec2 mineral)

		;Y un recurso de gas
		(recursos rec3 gas)

		;el centro de comando 1 se encuentra en la localización 11
		(construido cent_mand1)

		;El tipo de edificio es CentroDeMando
		(edificios cent_mand1 centro_de_mando)

		;indicamos donde se encuentra los edificios
		(en cent_mand1 loc11)

		;y las unidades tambien se encuentra en esa misma localizacion
		(en vce1 loc11)
		(en vce2 loc11)
		(en vce3 loc11)

		;las unidades esta libre
		(libre vce1)
		(libre vce2)
		(libre vce3)

		;los recursos se encuentra en las localizaciones
		(hay rec1 loc23)
		(hay rec2 loc33)
		(hay rec3 loc13)

	)
	(:goal
		(and
			;objetivo construir el barracon1 en la localización 32
			(construido barracon1)
			(en barracon1 loc32)
		)
	)
)