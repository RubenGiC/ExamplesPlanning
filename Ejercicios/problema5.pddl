(define (problem star_craft_prob5)
	(:domain star_craft5)
	(:objects
		loc11 loc12 loc13 loc14 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 - localizacion
		cent_mand1 extractor1 barracon1 bahia_de_ingenieria1 - edificio
		vce1 vce2 vce3 marine1 marine2 segador1 - unidad
		rec1 rec2 rec3 - recurso
		impulsar_segador - investigacion
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
		(edificios bahia_de_ingenieria1 bahia_de_ingenieria)

		;inicializando tipo de recurso para construir o reclutar
		(necesita extractor mineral)
		(necesita barracon mineral)
		(necesita barracon gas)
		(necesita bahia_de_ingenieria mineral)
		(necesita bahia_de_ingenieria gas)
		(necesita vce mineral)
		(necesita marine mineral)
		(necesita segador mineral)
		(necesita segador gas)
		(necesita impulsar_segador mineral)
		(necesita impulsar_segador gas)


		;indicamos el tipo de unidades
		(unidades vce1 vce)
		(unidades vce2 vce)
		(unidades vce3 vce)
		(unidades marine1 marine)
		(unidades marine2 marine)
		(unidades segador1 segador)

		;Indicamos los tipos de recursos
		(recursos rec1 mineral)
		(recursos rec2 mineral)
		(recursos rec3 gas)

		;el centro de comando 1 se encuentra en la localización 11
		(construido cent_mand1)

		;El tipo de edificio es CentroDeMando
		(edificios cent_mand1 centro_de_mando)

		;indicamos donde se encuentra los edificios
		(en cent_mand1 loc11)

		;y las unidades tambien se encuentra en esa misma localizacion
		(en vce1 loc11)

		;las unidades esta libre
		(libre vce1)

		;los recursos se encuentra en las localizaciones
		(hay rec1 loc23)
		(hay rec2 loc33)
		(hay rec3 loc13)

	)
	(:goal
		(and

			;que este construido el barracon1 en la localizacion 32
			(construido barracon1)
			(en barracon1 loc32)

			;que se recluten los marines y el segador en el barracon1
			;y que esten en sus localizaciones
			(reclutado marine1 barracon1)
			(en marine1 loc31)
			(libre marine1)
			(reclutado marine2 barracon1)
			(en marine2 loc24)
			(libre marine2)
			(reclutado segador1 barracon1)
			(en segador1 loc12)
			(libre segador1)
		)
	)
)