(define (domain star_craft6)
	(:requirements :strips :typing :fluents)
	(:types
		entidad localizacion recurso tipo tipoRecurso - object
		unidad edificio - entidad
		tipoEdificio tipoUnidad - tipo
	)
	(:constants
		vce marine segador - tipoUnidad
		centro_de_mando barracon extractor - tipoEdificio
		mineral gas - tipoRecurso
	)
	(:predicates

		;indico que una unidad o un edificio esta en una localización
		(en ?x - entidad ?loc - localizacion)

		;indico que hay un camino entre 2 localizaciones
		(camino ?loc1 ?loc2 - localizacion)

		;indico si que hay un edificio construido
		(construido ?edi - edificio)

		;indico que hay recursos en cierta localizacion
		(hay ?rec - recurso ?loc - localizacion)

		;indico que una unidad esta extrayendo recursos
		(extrayendo ?rec - tipoRecurso)

		;indico que la unidad esta libre
		(libre ?uni - unidad)

		;indico lo que necesita el edificio para construirse y tambien con las unidades
		(necesita ?x - tipo ?rec - tipoRecurso)

		;indico los tipos de edificios, unidades y recursos
		(unidades ?uni - unidad ?tip - tipoUnidad)
		(edificios ?edif - edificio ?tip - tipoEdificio)
		(recursos ?rec - recurso ?tip - tipoRecurso)

		;indico que se esta extrayendo gas o mineral
		(depositoEn ?loc -localizacion ?rec - tipoRecurso)

		;indico que ha sido reclutado
		(reclutado ?uni - unidad ?edi - edificio)

	)
	(:functions
		;indico la cantidad almacenada de cada tipo de recurso
		(cantidad ?tip_rec - tipoRecurso ?x)
	)

	;que una unidad se mueva de una localización a otra
	(:action navegar
		:parameters (?uni - unidad ?loc_ori - localizacion ?loc_des - localizacion)
		:precondition
			(and
				;que la unidad este en la localización origen
				(en ?uni ?loc_ori)

				;que la localización de origen y destino haya un camino
				(or 
					(camino ?loc_ori ?loc_des)
					(camino ?loc_des ?loc_ori)
				)
				;que esa unidad este libre
				(libre ?uni)
			)
		:effect
			(and
				;la unidad ya no esta en la localización de origen
				(not (en ?uni ?loc_ori))
				;y esta en la localización destino
				(en ?uni ?loc_des)
			)
	)

	;Asigna a una unidad la extracción de un recurso
	(:action asignar
		:parameters (?uni - unidad ?loc_rec - localizacion ?rec - recurso)
		:precondition
			(and ;tiene que cumplir que
				;esa unidad no este extrayendo recursos (que este libre)
				(libre ?uni)

				;que el recurso este en la localización dada
				(hay ?rec ?loc_rec)

				;que la unidad sea de tipo vce
				(unidades ?uni vce)

				;y que la unidad este en la misma localización que el recurso
				(en ?uni ?loc_rec)

				;dependiendo del tipo de recurso
				(or
					(recursos ?rec mineral)
					(and
						(recursos ?rec gas)
						(exists
							(?edi - edificio)
							(and 
								(edificios ?edi extractor)
								(construido ?edi)
							)
						)
				
					)
				)
			)
		:effect

			(and
				(not (libre ?uni))			

				(when
					(and (recursos ?rec gas))
					(and
						(depositoEn ?loc_rec gas)
						(extrayendo gas)
					)
				)
				(when (and (recursos ?rec mineral))
					(and
						(depositoEn ?loc_rec mineral)
						(extrayendo mineral)
					)
				)
			)
	)

	;construcción de un edificio
	(:action construir
		:parameters (?uni - unidad ?edi - edificio ?loc - localizacion)
		:precondition
			(and ;Para la construcción del edificio necesita

				;que haya una unidad libre (que no este extrayendo)
				(libre ?uni)

				;que esa unidad sea de tipo VCE
				(unidades ?uni vce)

				;que la unidad este en la localización donde se construira el edificio
				(en ?uni ?loc)
				(en ?edi ?loc)

				;que no se haya construido un edificio
				(not (construido ?edi))

				;comprueba que recursos necesita para construir el edificio
				(exists (?tip_edi - tipoEdificio)
					(and
						(edificios ?edi ?tip_edi)
						(or
							(and 
								(necesita ?tip_edi mineral)
								(not (necesita ?tip_edi gas))
								(extrayendo mineral)
							)
							(and 
								(necesita ?tip_edi gas)
								(not (necesita ?tip_edi mineral))
								(extrayendo gas)
							)
							(and 
								(necesita ?tip_edi mineral)
								(necesita ?tip_edi gas)
								(extrayendo mineral)
								(extrayendo gas)
							)
						)
					)
				)
			)
		:effect
			(and ;aplicara los siguientes cambios
				
				;que se ha construido el edificio indicado
				(construido ?edi)

				;en la localización indicada
				(en ?edi ?loc)
			)
	)

	;reclutar unidades
	(:action reclutar
		:parameters (?edi - edificio ?uni - unidad ?loc - localizacion)
		:precondition
			(and ;Para reclutar unidades necesita

				;dependiendo del tipo de unidad tiene que coincidir el tipo de edificio
				(or 
					(and
						(unidades ?uni vce)
						(edificios ?edi centro_de_mando)
						(en ?edi ?loc)
					)
					(and
						(or
							(unidades ?uni marine)
							(unidades ?uni segador)
						)
						(edificios ?edi barracon)
						(en ?edi ?loc)
					)
				)

				;necesita estar construido el edificio que los recluta
				(construido ?edi)

				;compruebo que no se ha creado antes esa unidad
				(not (exists (?loc2 - localizacion)
						(en ?uni ?loc2)
					)
				)

				;comprueba que recursos necesita para reclutar
				(exists (?tip_uni - tipoUnidad)
					(and
						(unidades ?uni ?tip_uni)
						(forall (?rec - tipoRecurso)
							(or
								(not (necesita ?tip_uni ?rec))
								(and
									(necesita ?tip_uni ?rec)
									(extrayendo ?rec)
								)
							)
						)
					)
				)
				
			)
		:effect
			(and ;aplicara los siguientes cambios
				
				;indico que recluto a la unidad en el edificio tal
				(reclutado ?uni ?edi)
				;en la localización indicada
				(en ?uni ?loc)
				;y esta libre
				(libre ?uni)
			)
	)

		
	;
	(:action recolectar
		:parameters (?rec - recurso ?loc - localizacion)
		:precondition
			(and
				;comprobamos que se esta extrayendo dicho recurso
				(exists (?tip_rec - tipoRecurso)
					(and
						(recursos ?rec ?tip_rec)
						(extrayendo ?tip_rec)
						(depositoEn ?loc ?tip_rec)

						(at start (at ?x 0))
						(at start
							(< 50 (cantidad ?tip_rec ?x))
						)
					)
				)

				;comprobamos que dicho recurso esta en la localización indicada
				(hay ?rec ?loc)

			)
		:effect

		(and
			
			(when
				(and (recursos ?rec gas))
				(and
					(increase (cantidad gas ?x) 10)
				)
			)
			(when (and (recursos ?rec mineral))
				(and
					(increase (cantidad mineral ?x) 10)
				)
			)
		)
	)
)