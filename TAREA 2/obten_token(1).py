# -*- coding: utf-8 -*-

# Implementación de un scanner mediante la codificación de un Autómata
# Finito Determinista como una Matríz de Transiciones
# Autor: Dr. Santiago Conant, Agosto 2014 (modificado en Agosto 2021)

import sys

# tokens
INT = 100  # Número entero
FLT = 101  # Número de punto flotante
OPB = 102  # Operador binario
LRP = 103  # Delimitador: paréntesis izquierdo
RRP = 104  # Delimitador: paréntesis derecho
END = 105  # Fin de la entrada
ASG = 106  # Operador de asignación
CCD = 107  # Operador condicional ?
CEL = 108  # Operador condicional :
OPR = 109  # Operador relacional
IDE = 110  # Identificador
CBI = 111  # delimitador condicional {
CBF = 112  # delimitador condicional }

ERR = 200  # Error léxico: palabra desconocida

# Matriz de transiciones: codificación del AFD
# [renglón, columna] = [estado no final, transición]
# Estados > 99 son finales (ACEPTORES)
# Caso especial: Estado 200 = ERROR
#      dig  op  (   ) raro esp  .   $   =   ?   :   !   <> letra {   }
MT = [[  1,OPB,LRP,RRP,  4,  0,  4,END,  5,CCD,CEL,  7,  8,  9, CBI,CBF], # edo 0 - estado inicial
      [  1,INT,INT,INT,  4,INT,  2,INT,INT,INT,INT,INT,INT,  4, INT,INT], # edo 1 - dígitos enteros
      [  3,  4,  4,  4,  4,ERR,  4,  4,  4,  4,  4,  4,  4,  4,   4,  4], # edo 2 - primer decimal flotante
      [  3,FLT,FLT,FLT,  4,FLT,  4,FLT,FLT,FLT,FLT,FLT,FLT,  4, FLT,FLT], # edo 3 - decimales restantes flotante
      [  4,  4,  4,  4,  4,ERR,  4,  4,  4,  4,  4,  4,  4,  4,   4,  4], # edo 4 - estado de error
      [ASG,ASG,ASG,ASG,  4,ASG,  4,ASG,  6,ASG,ASG,ASG,ASG,ASG, ASG,ASG], # edo 5 - asignación
      [OPR,OPR,OPR,OPR,  4,OPR,  4,OPR,OPR,OPR,OPR,OPR,OPR,OPR, OPR,OPR], # edo 6 - segundo caracter relacional
      [  4,  4,  4,  4,  4,ERR,  4,  4,  6,  4,  4,  4,  4,  4,   4,  4], # edo 7 - operador relacional !
      [OPR,OPR,OPR,OPR,  4,OPR,  4,OPR,  6,OPR,OPR,OPR,OPR,OPR, OPR,OPR], # edo 8 - operadores relacionales
      [  4,IDE,IDE,IDE,  4,IDE,  4,IDE,IDE,IDE,IDE,IDE,IDE,  9, IDE,IDE]] # edo 9 - identificadores

# Filtro de caracteres: regresa el número de columna de la matriz de transiciones
# de acuerdo al caracter dado
def filtro(c):
    """Regresa el número de columna asociado al tipo de caracter dado(c)"""
    if c == '0' or c == '1' or c == '2' or \
       c == '3' or c == '4' or c == '5' or \
       c == '6' or c == '7' or c == '8' or c == '9': # dígitos
        return 0
    elif c == '+' or c == '-' or c == '*' or \
         c == '/': # operadores
        return 1
    elif c == '(': # delimitador (
        return 2
    elif c == ')': # delimitador )
        return 3
    elif c == ' ' or ord(c) == 9 or ord(c) == 10 or ord(c) == 13: # blancos
        return 5
    elif c == '.': # punto
        return 6
    elif c == '$': # fin de entrada
        return 7
    elif c == '=': # asignación
        return 8
    elif c == '?': # condicional ?
        return 9
    elif c == ':': # condicional :
        return 10
    elif c == '!': # operador !
        return 11
    elif c == '<' or c == '>': # operador relacional
        return 12
    elif ord(c) >= ord('a') and ord(c) <= ord('z'): # letra
        return 13
    elif c == '{': # delimitador {
        return 14
    elif c == '}': # delimitador }
        return 15
    else: # caracter raro
        return 4

_c = None    # siguiente caracter
_leer = True # indica si se requiere leer un caracter de la entrada estándar

# Función principal: implementa el análisis léxico
def obten_token():
    """Implementa un analizador léxico: lee los caracteres de la entrada estándar"""
    global _c, _leer
    edo = 0 # número de estado en el autómata
    lexema = "" # palabra que genera el token
    while (True):
        while edo < 100:    # mientras el estado no sea ACEPTOR ni ERROR
            if _leer: _c = sys.stdin.read(1)
            else: _leer = True
            edo = MT[edo][filtro(_c)]
            if edo < 100 and edo != 0: lexema += _c
        if edo == INT:    
            _leer = False # ya se leyó el siguiente caracter
            print("Entero", lexema)
            return INT
        elif edo == FLT:   
            _leer = False # ya se leyó el siguiente caracter
            print("Flotante", lexema)
            return FLT
        elif edo == OPB:   
            lexema += _c  # el último caracter forma el lexema
            print("Operador", lexema)
            return OPB
        elif edo == LRP:   
            lexema += _c  # el último caracter forma el lexema
            print("Delimitador", lexema)
            return LRP
        elif edo == RRP:  
            lexema += _c  # el último caracter forma el lexema
            print("Delimitador", lexema)
            return RRP
        elif edo == END:
            print("Fin de expresion")
            return END
        elif edo == ASG:    
            _leer = False # ya se leyó el siguiente caracter
            print("Asignación", lexema) 
            return ASG
        elif edo == CCD:  
            lexema += _c  # el último caracter forma el lexema
            print("Condicional", lexema)
            return CCD
        elif edo == CEL:  
            lexema += _c  # el último caracter forma el lexema
            print("Condicional", lexema)
            return CEL
        elif edo == OPR:  
            _leer = False # ya se leyó el siguiente caracter
            print("Relacional", lexema)
            return OPR
        elif edo == IDE:  
            _leer = False # ya se leyó el siguiente caracter
            print("Identificador", lexema)
            return IDE
        elif edo == CBI:  
            lexema += _c  # el último caracter forma el lexema
            print("Delimitador", lexema)
            return CBI
        elif edo == CBF:  
            lexema += _c  # el último caracter forma el lexema
            print("Delimitador", lexema)
            return CBF
        else:   
            _leer = False # el último caracter no es raro
            print("ERROR! palabra ilegal", lexema)
            return ERR
            
        
    

