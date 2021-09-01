# -*- coding: utf-8 -*-

# Implementación de un scanner mediante la codificación de un Autómata
# Finito Determinista como una Matríz de Transiciones
# Autor: 

import sys

# Strings de apoyo para formar el archivo HTML
htmlFormatoInicio = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><link rel='stylesheet' href='resalta_sintaxis.css'></head><body>"
htmlFormatoCierre = "</body></html>"
htmlBody = ""

# tokens
NUM = 100  # Número entero
SIM = 101  # Simbolo letras minusculas
BOO = 102  # Booleano
STR = 103  # String letras, digitos y espacios
LRP = 104  # Delimitador: paréntesis izquierdo
RRP = 105  # Delimitador: paréntesis derecho
END = 106  # Fin de la entrada
ESP = 110

ERR = 200  # Error léxico: palabra desconocida

# Matriz de transiciones: codificación del AFD
# [renglón, columna] = [estado no final, transición]
# Estados > 99 son finales (ACEPTORES)
# Caso especial: Estado 200 = ERROR
#      dig let   #   "  (    )   $ esp   t   f rar  
MT = [[  1,  2,  5,  3,LRP,RRP,END,  0,  2,  2,  4], # edo 0 - estado inicial
      [  1,  4,  4,  4,NUM,NUM,NUM,NUM,  4,  4,  4], # edo 1 - dígitos enteros
      [  4,  2,  4,  4,SIM,SIM,SIM,SIM,  2,  2,  4], # edo 2 - simbolos letras minusculas
      [  3,  3,  4,  6,  4,  4,  4,  3,  3,  3,  4], # edo 3 - String letras, digitos y espacios
      [  4,  4,  4,  4,  4,  4,  4,ERR,  4,  4,  4], # edo 4 - estado de error
      [  4,  4,  4,  4,  4,  4,  4,  4,  7,  7,  4], # edo 5 - booleano
      [  4,  4,  4,  4,STR,STR,STR,STR,  4,  4,  4], # edo 6 - fin del string
      [  4,  4,  4,  4,BOO,BOO,BOO,BOO,  4,  4,  4]] # edo 7 - fin del booleano

# Filtro de caracteres: regresa el número de columna de la matriz de transiciones
# de acuerdo al caracter dado
def filtro(c):
    """Regresa el número de columna asociado al tipo de caracter dado(c)"""
    global htmlBody
    if ord(c) >= 48 and ord(c) <= 57: # dígitos
        return 0
    elif ord(c) > 96 and ord(c) < 123:
        if c == 't':
            return 8 
        elif c == 'f':
            return 9
        return 1 # letras
    elif c == '#': # caracter para bool
        return 2
    elif c == '"' or c == '“' or c =='”': # para formar strings
        return 3
    elif c == ' ' or ord(c) == 10 or ord(c) == 9 or ord(c) == 13:
        return 7
    elif c == '(': # delim izquierdo
        return 4
    elif c == ')': # delim derecho
        return 5
    elif c == '$': # fin de entrada
        return 6
    else: # caracter raro
        return 10

_c = None    # siguiente caracter
_leer = True # indica si se requiere leer un caracter de la entrada estándar

def tipo_espacio(c):
    if c == ' ':
        return " "
    elif ord(c) == 10 or ord(c) == 13:
        return "<br>"
    elif ord(c) == 9:
        return "&emsp;"

# Función principal: implementa el análisis léxico
def obten_token():
    """Implementa un analizador léxico: lee los caracteres de la entrada estándar"""
    global _c, _leer, htmlBody
    edo = 0 # número de estado en el autómata
    lexema = "" # palabra que genera el token
    while (True):
        while edo < 100:    # mientras el estado no sea ACEPTOR ni ERROR
            if _leer: _c = sys.stdin.read(1)
            else: _leer = True

            if (edo == 0 and filtro(_c) == 7):
                htmlBody += tipo_espacio(_c)

            edo = MT[edo][filtro(_c)]
            if edo < 100 and edo != 0: lexema += _c
        if edo == NUM:    
            _leer = False # ya se leyó el siguiente caracter
            print("Numero", lexema)
            htmlBody += '<span class="numero">' + lexema + '</span>'
            return NUM
        elif edo == SIM:   
            _leer = False # ya se leyó el siguiente caracter
            print("Simbolo", lexema)
            htmlBody += '<span class="simbolo">' + lexema + '</span>'
            return SIM
        elif edo == BOO:
            _leer = False # ya se leyó el siguiente caracter
            print("Booleano", lexema)
            htmlBody += '<span class="booleano">' + lexema + '</span>'
            return BOO
        elif edo == STR:
            _leer = False # ya se leyó el siguiente caracter
            print("String", lexema)
            htmlBody += '<span class="string">' + lexema + '</span>'
            return STR
        elif edo == LRP:   
            lexema += _c  # el último caracter forma el lexema
            print("Delimitador", lexema)
            htmlBody += '<span class="parentesis">' + lexema + '</span>'
            return LRP
        elif edo == RRP:  
            lexema += _c  # el último caracter forma el lexema
            print("Delimitador", lexema)
            htmlBody += '<span class="parentesis">' + lexema + '</span>'
            return RRP
        elif edo == END:
            print("Fin de expresion")
            htmlBody += '<span class="dollarSign">$</span>'
            return END
        else:   
            _leer = False # el último caracter no es raro
            print("ERROR! palabra ilegal", lexema)
            htmlBody += '<span class="error">' + lexema + ' >> ERROR SINTACTICO << </span>'
            return ERR

def error_sintactico():
    global htmlBody
    htmlBody += '<span class="error"> >> ERROR SINTACTICO << </span>'

def crear_archivo():
    print("creando archivo")
    arch = open("prueba.html", "w")
    arch.write(htmlFormatoInicio)
    arch.write(htmlBody)
    arch.write(htmlFormatoCierre)
    arch.close()


#if __name__ == '__main__':
#    obten_token()