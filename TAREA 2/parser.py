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
# Autores:  Luis Angeles / Adrianda Fernández / Carlos Gálvez

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
        scanner.error_sintactico()
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

    scanner.crear_archivo()

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
    else:
        if (token != scanner.ERR and token != scanner.END):
            scanner.error_sintactico()
        error("expresion mal iniciada")

# modulo elementos
def elementos():
    if token == scanner.RRP:
        return
    else:    
        exp()
        elementos()

# Termina con un mensaje de error
def error(mensaje):
    global token
    print("ERROR:", mensaje)

    if token != scanner.END:
        token = scanner.obten_token()
    else:
        scanner.crear_archivo()
        exit()

    # sys.exit(1)
    
        
if __name__ == '__main__':
    parser()