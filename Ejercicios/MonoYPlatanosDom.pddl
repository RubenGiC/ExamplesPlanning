(define (domain mono)
    (:requirements :strips :typing)
    (:types
        movible localizacion - object
        mono caja - movible
    )
    (:predicates
        (en ?obj - movible ?x - localizacion)
        (tienePlatano ?m - mono)
        (sobre ?m - mono ?c - caja)
        (platanoEn ?x - localizacion)
    )
    
    (:action cogerPlatanos
        :parameters (?m - mono ?c - caja ?x - localizacion)
        :precondition
            (and
                (sobre ?m ?c)
                (platanoEn ?x)
                (en ?m ?x)
            )
        :effect
            (and
                (tienePlatano ?m)
            )
    )
    
    (:action bajarCaja
        :parameters (?m - mono ?c - caja)
        :precondition
            (and
                (sobre ?m ?c)
            )
        :effect
            (and
                (not (sobre ?m ?c))
            )
    )
    
    (:action moverCaja
        :parameters (?m - mono ?c - caja ?x1 - localizacion ?x2 - localizacion)
        :precondition
            (and
                (en ?m ?x1)
                (en ?c ?x1)
                (not (sobre ?m ?c))
            )
        :effect
            (and
                (not (en ?m ?x1))
                (not (en ?c ?x1))
                (en ?m ?x2)
                (en ?c ?x2)
            )
    )
    
    (:action subirCaja
        :parameters (?m - mono ?c - caja ?x - localizacion)
        :precondition
            (and
                (en ?m ?x)
                (en ?c ?x)
                (not (sobre ?m ?c))
            )
        :effect
            (and
                (sobre ?m ?c)
            )
    )
)