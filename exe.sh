#!/bin/bash
echo "Ejecutando Metric-FF"

case $1 in
	mono)
		echo "MONO"
		dom=Ejercicios/MonoYPlatanosDom.pddl
		prob=Ejercicios/MonoYPlatanosProb.pddl
		;;
	1)
		echo "Ejercicio 1"
		dom=Ejercicios/dominio1.pddl
		prob=Ejercicios/problema1.pddl
		;;
	2)
		echo "Ejercicio 2"
		dom=Ejercicios/dominio2.pddl
		prob=Ejercicios/problema2.pddl
		;;
	3)
		echo "Ejercicio 3"
		dom=Ejercicios/dominio3.pddl
		prob=Ejercicios/problema3.pddl
		;;
	4)
		echo "Ejercicio 4"
		dom=Ejercicios/dominio4.pddl
		prob=Ejercicios/problema4.pddl
		;;
	prueba)
		echo "Pruebas"
		dom=Ejercicios/dominio4.pddl
		prob=Ejercicios/pruebas.pddl
		;;
	*)
		echo "DEFAULT"
		dom=Ejercicios/MonoYPlatanosDom.pddl
		prob=Ejercicios/MonoYPlatanosProb.pddl
		;;
esac

./ff -o $dom -f $prob -O -g 1 -h 1