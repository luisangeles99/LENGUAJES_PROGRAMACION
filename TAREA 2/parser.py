# -*- coding: utf-8 -*-
# Implementación de un parser
# Reconoce expresiones mediante la gramática:
# INST -> id = <EXP> $
# EXP -> EXP op EXP | EXP -> (EXP) | COND | cte | id
# COND -> { EXP opr EXP ? EXP : EXP }
# la cual fué modificada para eliminar ambigüedad a:
# INST -> id = EXP $
# EXP  -> (EXP) EXP1 | COND EXP1 | cte EXP1 | id EXP1
# EXP1 -> op EXP EXP1 | vacío
# COND -> { EXP opr EXP ? EXP : EXP }
# los elementos léxicos (delimitadores, constantes y operadores)
# son reconocidos por el scanner
#
# Autor: Dr. Santiago Conant, Agosto 2014 (modificado Agosto 2015)
# Autores: 

import sys
import obten_token as scanner

# Strings de apoyo para formar el archivo HTML
htmlFormatoInicio = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><link rel='stylesheet' href='resalta_sintaxis.css'></head><body>"
htmlFormatoCierre = "</body></html>"

# Empata y obtiene el siguiente token
def match(tokenEsperado):
    global token
    if token == tokenEsperado:
        token = scanner.obten_token()
    else:
        error("token equivocado")

# Función principal: implementa el análisis sintáctico
def parser():
    global token 
    token = scanner.obten_token() # inicializa con el primer token
    inst()
    if token == scanner.END:
        print("Expresion bien construida!!")
    else:
        error("expresion mal terminada")

# Módulo que reconoce instrucciones
def inst():
    match(scanner.IDE) # identificador
    match(scanner.ASG) # asignación =
    exp()

# Módulo que reconoce expresiones
def exp():
    if token == scanner.INT or token == scanner.FLT:
        match(token) # reconoce constantes
        exp1()
    elif token == scanner.LRP:
        match(token) # reconoce delimitador (
        exp()
        match(scanner.RRP) # delimitador )
        exp1()
    elif token == scanner.CBI: # delimitador {
        cond()
        exp1()
    elif token == scanner.IDE:
        match(token) # reconoce identificador
        exp1()
    else:
        error("expresion mal iniciada")

# Módulo auxiliar para reconocimiento de expresiones
def exp1():
    if token == scanner.OPB:
        match(token) # operador binario
        exp()
        exp1()

# Módulo auxiliar para reconocimiento de condicionales
def cond():
    match(scanner.CBI) # delimitador {
    exp()
    match(scanner.OPR) # operador relacional
    exp()
    match(scanner.CCD) # condicional ?
    exp()
    match(scanner.CEL) # condicional :
    exp()
    match(scanner.CBF) # delimitador }

# Termina con un mensaje de error
def error(mensaje):
    print("ERROR:", mensaje)
    sys.exit(1)
    
        
if __name__ == '__main__':
    parser()