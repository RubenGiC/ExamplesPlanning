(define (domain star_craft1)
	(:requirements :strips :typing)
	(:types
		entidad localizacion recurso tipoEdificio tipoUnidad - object
		unidad edificio - entidad
	)
	(:constants
		vce - tipoUnidad
		centro_de_mando barracon extractor - tipoEdificio
		mineral gas - recurso
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
		(extrayendo ?rec - recurso)

		;indico que la unidad esta libre
		(libre ?uni - unidad)

		;indico lo que necesita el edificio para construirse
		(necesita ?edi - edificio ?rec - recurso)

		;indico los tipos de edificios, unidades y recursos
		(unidades ?uni - unidad ?tip - tipoUnidad)
		(edificios ?edif - edificio ?tip - tipoEdificio)
		(recursos ?rec - recurso ?tip - recurso)

		;indico que se esta extrayendo gas
		(depositoEn ?loc -localizacion ?rec - recurso)

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
							(edificios ?edi extractor)
							(construido ?edi)
						)
					)
				)
			)
		:effect
			(when
				(and
					(recursos ?rec gas)
				)
				(and
					(depositoEn ?loc gas)
				)
			)
			(when
				(and
					(recursos ?rec mineral)
				)
				(and
					(depositoEn ?loc mineral)
				)
			)
			(and
				(not (libre ?uni))
				(extrayendo ?rec)
			)
	)

	;construcción de un edificio
	(:action construir
		:parameters (?uni - unidad ?edi - edificio ?loc - localizacion ?rec - recurso)
		:precondition
			(and ;Para la construcción del edificio necesita

				;que haya una unidad libre (que no este extrayendo)
				(libre ?uni)

				;que la unidad este en la localización donde se construira el edificio
				(en ?uni ?loc)

				;que no se haya construido un edificio
				(not (construido ?edi))

				;que se este extrayendo un recurso
				(extrayendo ?rec)

				;y que dicho recurso que se esta extrayendo sea el que necesite para construir el edificio
				(necesita ?edi ?rec)

				;ademas
				(or
					;que no haya un edificio extractor construido
					(not (edificioEs ?edi extractor))
					;o que este construido el edificio extractor y tenga un deposito de gas
					(and
						(edificioEs ?edi extractor)
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