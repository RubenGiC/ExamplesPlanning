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

		;indico si que hay un edificio construido en la localizacion indicada
		(construido ?edi - edificio)

		;indico que hay recursos en cierta localizacion
		(hay ?rec - recurso ?loc - localizacion)

		;indico que una unidad esta extrayendo recursos
		(extrayendo ?rec - recurso)

		;indico que la unidad esta libre
		(libre ?uni - unidad)

		;indico el tipo de unidad
		(unidades ?uni - unidad ?tip - tipoUnidad)
		;indico el tipo de edificio
		(edificios ?edif - edificio ?tip - tipoEdificio)
		;indico el tipo de recurso
		(recursos ?rec - recurso ?tip - recurso)
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
			)
		:effect
			(and
				(not (libre ?uni))
				(extrayendo ?rec)
			)
	)
)