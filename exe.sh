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
	prueba1)
		echo "Prueba Ejercicio 1"
		dom=Ejercicios/dominio1.pddl
		prob=Ejercicios/pruebas.pddl
		;;
	*)
		echo "DEFAULT"
		dom=Ejercicios/MonoYPlatanosDom.pddl
		prob=Ejercicios/MonoYPlatanosProb.pddl
		;;
esac

./ff -o $dom -f $prob -O -g 1 -h 1