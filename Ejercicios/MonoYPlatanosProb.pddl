(define (problem monosp1)
    (:domain mono)
    (:objects
        mono1 - mono
        caja1 - caja
        localizacion1 localizacion2 localizacion3 - localizacion
    )
    (:init
        (en caja1 localizacion2)
        (en mono1 localizacion2)
        (platanoEn localizacion3)
        (sobre mono1 caja1)
        
    )
    (:goal
        (and
             (tienePlatano mono1)
        )
    )
)