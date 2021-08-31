# -*- coding: utf-8 -*-
# Implementación de un parser
# Reconoce expresiones mediante la gramática:
# PROG -> <EXP><PROG> | $
# EXP -> <ATOMO> | <LISTA> 
# ATOMO -> SIMBOLO | <CONSTANTE>
# CONSTANTE -> NUMERO | BOOLEANO | STRING
# LISTA -> (<ELEMENTOS>)
# ELEMENTOS -> <EXP><ELEMENTOS> | vacío
# No existe ambigüedad en el lenguaje
# los elementos léxicos son reconocidos por el scanner
#
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
    prog()
    if token == scanner.END:
        print("Expresion bien construida!!")
    else:
        error("expresion mal terminada")

# modulo
def prog():
    if token == scanner.END:
        pass
    else:
        exp()
        prog()


# Módulo que reconoce expresiones
def exp():
    if token == scanner.NUM:
        match(token) # reconoce numeros enteros
    elif token == scanner.SIM:
        match(token) # reconoce simbolos
    elif token == scanner.BOO:
        match(token) # reconoce booleanos
    elif token == scanner.STR:
        match(token) # reconoce strings
    elif token == scanner.LRP:
        match(token)
        elementos()
        match(scanner.RRP)
    elif token == scanner.RRP:
        match(token)
    else:
        error("expresion mal iniciada")

# modulo elementos
def elementos():
    if token == scanner.RRP:
        pass
    else:    
        exp()
        elementos()

# Termina con un mensaje de error
def error(mensaje):
    print("ERROR:", mensaje)
    sys.exit(1)
    
        
if __name__ == '__main__':
    parser()