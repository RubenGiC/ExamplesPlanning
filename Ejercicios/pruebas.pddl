(define (problem star_craft_prob2)
	(:domain star_craft2)
	(:objects
		loc1 loc2 loc3 loc4 - localizacion
		cent_mand1 - edificio
		vce1 - unidad
		rec1 - recurso
	)
	(:init
		;inicializo las conexiones de las localizaciones
		(camino loc1 loc2)
		(camino loc4 loc3)
		(camino loc4 loc2)

		;el centro de comando 1 se encuentra en la localización 1
		(construido cent_mand1 loc1)

		;y la unidad tambien se encuentra en esa misma localizacion
		(en vce1 loc1)

		;los minerales se encuentra en las localizacione 3
		(hay rec1 loc3)
	)
	(:goal
		(and
			(extrayendo vce1 rec1)
		)
	)
)