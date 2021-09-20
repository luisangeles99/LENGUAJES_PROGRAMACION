#lang racket
; Ejercicio 5 Bitor calcular or lógico entre bits dados como elementos de dos listas dadas.
; Asumir tamaño de listas y numero

(define (bitor2 lista1 lista2) ; sin usar or
  (if (null? lista1)
      '()
      (cond ((eq? (car lista1) 1) (cons 1 (bitor2 (cdr lista1) (cdr lista2))))
            ((eq? (car lista2) 1) (cons 1 (bitor2 (cdr lista1) (cdr lista2))))
            (else (cons 0 (bitor (cdr lista1) (cdr lista2)))))))

(define (bitor lista1 lista2) ; usando or
  (cond ((null? lista1) '())
        ((or (eq? (car lista1) 1) (eq? (car lista2) 1)) (cons 1 (bitor (cdr lista1) (cdr lista2))))
        (else (cons 0 (bitor (cdr lista1) (cdr lista2))))))

; Ejercicio 6 función hexadecimal obtener lista de numeros y letras representando la codificacion
; hexadecimal recibe numeros y letras 

(define (hexadecimal n)
  (if (zero? n)
      '(0)
      (reverse(hexadecimal-aux (binToDec n))))) ; se usa funcion auxiliar con el valor ya en decimal

(define (hexadecimal-aux n) ; funcion recursiva que genera la lista
  (if (zero? n)
      '()
      (if (> (modulo n 16) 9)
          (cons (caracter (modulo n 16)) (hexadecimal-aux (quotient n 16)))
      (cons (modulo n 16) (hexadecimal-aux (quotient n 16))))))

(define (binToDec n) ; funcion para pasar de binario a decimal
  (if (zero? n)
      0
      (+ (modulo n 10) (* 2 (binToDec (quotient n 10)))))) 

(define (caracter n) ; funcion que regresa caracter correspondiente a numero
  (cond ((eq? n 10) 'a)
        ((eq? n 11) 'b)
        ((eq? n 12) 'c)
        ((eq? n 13) 'd)
        ((eq? n 14) 'e)
        ((eq? n 15) 'f)))
        

; Ejercicio 7 función recursiva decimal convierte argumento dado como numero binario por una lista
; valor decimal
(define (decimal lista)
  (if (null? lista)
      0
      (decimal-aux (reverse lista) 0)))

(define (decimal-aux lista pos)
  (if (null? lista)
        0
        (if (zero? (car lista))
           (decimal-aux (cdr lista) (+ pos 1)) 
        (+ (expt 2 pos) (decimal-aux (cdr lista) (+ pos 1))))))
  

; Ejercicio 8 expresion? determinar si expresion aritmetica en notacion prefija como una lista
; imbricada se especifó correctamente



; Ejercicio 9 Palindromo recursivo generando el patron palindromo intercalando a o b N veces

(define (palindromo n)
  (cond ((eq? n 1) (list 'a))
        ((<= n 0) '())
        ((> (modulo n 2) 0) (list 'a (palindromo (- n 1)) 'a))
        (else (list 'b (palindromo (- n 1)) 'b))))

; Ejercicio 10 inversiontotal, invertir lista imbricada con todas las listas anidadas

(define (inversiontotal lista) ; sin usar built in reverse
  (inverse-aux lista '()))

(define (inverse-aux lista prev)
  (cond ((null? lista) prev)
        ((list? (car lista))
         (inverse-aux (cdr lista) (cons(inverse-aux (car lista) '()) prev)))
        (else (inverse-aux (cdr lista) (cons (car lista) prev)))))

   
  