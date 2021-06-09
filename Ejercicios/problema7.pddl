(define (problem star_craft_prob7)
	(:domain star_craft7)
	(:objects
		loc11 loc12 loc13 loc14 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 - localizacion
		cent_mand1 extractor1 barracon1 - edificio
		vce1 vce2 vce3 marine1 marine2 segador1 - unidad
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

		;inicializamos el tiempo total a 0
		(= (tiempo_total) 0)

		;inicializo los almacenados
		(= (almacenado gas) 0)
		(= (almacenado mineral) 0)

		;inicializo el numero de asignados de cada recurso
		(= (nAsignados loc23) 0)
		(= (nAsignados loc33) 0)
		(= (nAsignados loc13) 0)

		;indicamos el tipo de edificio
		(edificios extractor1 extractor)
		(edificios barracon1 barracon)

		;inicializando tipo de recurso para construir o reclutar
		(= (necesita extractor mineral) 33)
		(= (necesita extractor gas) 0)
		(= (necesita barracon mineral) 50)
		(= (necesita barracon gas) 20)
		(= (necesita vce mineral) 10)
		(= (necesita vce gas) 0)
		(= (necesita marine mineral) 20)
		(= (necesita marine gas) 10)
		(= (necesita segador mineral) 30)
		(= (necesita segador gas) 30)

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

		;indicamos donde se encuentra el edificio
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
	(:metric minimize (tiempo_total))
)