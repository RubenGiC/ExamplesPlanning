(define (domain star_craft6)
	(:requirements :strips :typing :fluents)
	(:types
		;indico como objetos las entidades, la localización el recurso,
		;un subgrupo de tipo y el tipo de recurso
		entidad localizacion recurso tipo tipoRecurso - object

		;en entidad meto la unidad y el edificio
		unidad edificio - entidad

		;y en el subtipo tipo meto los tipos de unidad y edificio
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
		(almacenado ?tip_rec - tipoRecurso)

		;indico el numero de unidades asignadas para extraer un recurso de una 
		;localización concreta
		(nAsignados ?loc - localizacion)

		;indico lo que necesita el edificio para construirse y tambien con las 
		;unidades, el tipo de recurso y su cantidad
		(necesita ?tip - tipo ?rec - tipoRecurso)
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

				;incrementa el numero unidades asignadas a ese recurso en esa localización
				(increase (nAsignados ?loc_rec) 1)
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

				;que no haya ningun edificio construido en esa localización
				(not (exists (?edi2 - edificio)
						(and
							(construido ?edi2)
							(en ?edi2 ?loc)
						)
					)
				)

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
				;y que la cantidad a necesitar la tenga el almacen
				(exists (?tip_edi - tipoEdificio)
					(and
						;indico el tipo de edificio que es
						(edificios ?edi ?tip_edi)

						;comprueba que recursos necesita
						(or

							;y si necesita solo mineral, que tenga la cantidad que 
							;necesita en el almacen y que se este extrayendo dicho mineral
							(and 
								(>= (almacenado mineral) (necesita ?tip_edi mineral))
								(<= (necesita ?tip_edi gas) 0)
								(extrayendo mineral)
							)
							;lo mismo pero con gas
							(and 
								(>= (almacenado gas) (necesita ?tip_edi gas))
								(<= (necesita ?tip_edi mineral) 0)
								(extrayendo gas)
							)
							;y lo mismo pero con ambos recursos
							(and 
								(>= (almacenado mineral) (necesita ?tip_edi mineral))
								(>= (almacenado gas) (necesita ?tip_edi gas))
								(extrayendo mineral)
								(extrayendo gas)
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
					;o que no sea un extractor lo que se va a construir
					(not (edificios ?edi extractor))
				)
			)
		:effect
			(and ;aplicara los siguientes cambios
				
				;que se ha construido el edificio indicado
				(construido ?edi)

				;en la localización indicada
				(en ?edi ?loc)

				;y dependiendo del tipo de edificio se le restara ciertos recursos
				(when (edificios ?edi extractor)
					(and
						(decrease (almacenado mineral) (necesita extractor mineral))
					)
				)

				(when (edificios ?edi barracon)
					(and
						(decrease (almacenado mineral) (necesita barracon mineral))
						(decrease (almacenado gas) (necesita barracon gas))
					)
				)
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
						(and
							(en ?uni ?loc2)
						)
					)
				)

				;comprueba que recursos necesita para reclutar
				(exists (?tip_uni - tipoUnidad)
					(and
						(unidades ?uni ?tip_uni)
						(forall (?rec - tipoRecurso)
							(or
								(<= (necesita ?tip_uni ?rec) 0)
								(and
									(>= (almacenado ?rec) (necesita ?tip_uni ?rec))
									(extrayendo ?rec)
								)
							)
						)
					)
				)
				
			)
		:effect
			(and ;aplicara los siguientes cambios

				;consumimos los recursos necesarios
				(when (unidades ?uni vce)
					(and
						(decrease (almacenado mineral) (necesita vce mineral))
					)
				)

				(when (unidades ?uni marine)
					(and
						(decrease (almacenado mineral) (necesita marine mineral))
						(decrease (almacenado gas) (necesita marine gas))
					)
				)

				(when (unidades ?uni segador)
					(and
						(decrease (almacenado mineral) (necesita segador mineral))
						(decrease (almacenado gas) (necesita segador gas))
					)
				)
				
				;indico que recluto a la unidad en el edificio tal
				(reclutado ?uni ?edi)
				;en la localización indicada
				(en ?uni ?loc)
				;y esta libre
				(libre ?uni)
			)
	)

		
	;recolecta los recursos
	(:action recolectar
		:parameters (?rec - recurso ?loc - localizacion)
		:precondition
			(and
				;compruebo que la localización coincide con el recurso
				(hay ?rec ?loc)

				;comprobamos que se esta extrayendo dicho recurso
				;y que el incremento no supere el tope del almacenado
				(exists (?tip_rec - tipoRecurso)
					(and
						(recursos ?rec ?tip_rec)
						(extrayendo ?tip_rec)
						(depositoEn ?loc ?tip_rec)

				;el calculo seria almacen += numero_unidades_extrayendo_en_loc * 10
						(<= 
							(+ 
								(almacenado ?tip_rec)
								(* 
									10 (nAsignados ?loc)
								) 
							) 
						60)
					)
				)

				;comprobamos que dicho recurso esta en la localización indicada
				(hay ?rec ?loc)

			)
		:effect

		(and
			;incrementamos el numero de recursos del almacen
			(when
				(and (recursos ?rec gas))
				(and
					(increase (almacenado gas) (* 10 (nAsignados ?loc)))
				)
			)
			(when (and (recursos ?rec mineral))
				(and
					(increase (almacenado mineral) (* 10 (nAsignados ?loc)))
				)
			)
		)
	)
)