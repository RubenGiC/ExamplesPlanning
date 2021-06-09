(define (domain star_craft2)
	(:requirements :strips :typing)
	(:types
		;indico como objetos las entidades, la localización, el recurso,
		;, el tipo de recurso y el subtipo
		entidad localizacion recurso tipoRecurso - object

		;en entidad meto la unidad y el edificio
		unidad edificio - entidad

		;y en el subtipo tipo meto los tipos de unidad y edificio
		tipoEdificio tipoUnidad - tipo
	)
	(:constants
		vce - tipoUnidad
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

		;indico lo que necesita el edificio para construirse
		(necesita ?x - tipo ?rec - tipoRecurso)

		;indico los tipos de edificios, unidades y recursos
		(unidades ?uni - unidad ?tip - tipoUnidad)
		(edificios ?edif - edificio ?tip - tipoEdificio)
		(recursos ?rec - recurso ?tip - tipoRecurso)

		;indico que se esta extrayendo gas o mineral
		(depositoEn ?loc -localizacion ?rec - tipoRecurso)

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

				;que la unidad sea de tipo vce, porque entiendo que es el unico tipo 
				;de unidad que se encarga de extraer los recursos
				(unidades ?uni vce)

				;y que la unidad este en la misma localización que el recurso
				(en ?uni ?loc_rec)

				;dependiendo del tipo de recurso necesitara o no construir un edificio
				(or
					(recursos ?rec mineral)

					;si es de tipo gas necesita tener construido un extractor
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
				;pasa a no estar libre
				(not (libre ?uni))
			

				;si es el recurso gas indico que se esta extrayendo y que hay un 
				;deposito de gas en la localización dada.
				(when
					(and (recursos ?rec gas))
					(and
						(depositoEn ?loc_rec gas)
						(extrayendo gas)
					)
				)

				;si es el recurso mineral indico que se esta extrayendo y que hay un 
				;deposito de mineral en la localización dada.
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
		:parameters (?uni - unidad ?edi - edificio ?loc - localizacion ?rec - recurso)
		:precondition
			(and ;Para la construcción del edificio necesita

				;que haya una unidad libre (que no este extrayendo)
				(libre ?uni)

				;que esa unidad sea de tipo VCE
				(unidades ?uni vce)

				;que la unidad este en la localización donde se construira el edificio
				(en ?uni ?loc)

				;y puede que este definido o no el lugar donde se va a construir el edificio
				(or
					(en ?edi ?loc)
					(not (en ?edi ?loc))
				)


				;que no se haya construido el edificio
				(not (construido ?edi))

				;comprueba que recursos necesita para construir el edificio
				(exists (?tip_edi - tipoEdificio)
					(and
						;indico el tipo de edificio que es
						(edificios ?edi ?tip_edi)
						
						;comprueba que recursos necesita
						(forall (?rec - tipoRecurso)
							(or
								(not (necesita ?tip_edi ?rec))
								(and
									(necesita ?tip_edi ?rec)
									(extrayendo ?rec)
								)
							)
						)
					)
				)

				;ademas
				(or
					;si el edificio a construir es un extractor, tiene que construirse
					;en la misma localización donde este el recurso gas
					(and
						(edificios ?edi extractor)
						(exists (?rec - recurso)
							(and
								(recursos ?rec gas)
								(hay ?rec ?loc)
							)
						)
					)
					;o que este construido el edificio extractor y tenga un deposito de gas
					(and
						(edificios ?edi extractor)
						(depositoEn ?loc gas)
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

		
	
)