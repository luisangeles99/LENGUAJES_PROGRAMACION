#lang racket
; Adriana Fernández López A01197148
; Luis Angeles A01273884
;
; Tarea 4

; SECCION 1
; 1a - Funcion que elimina la columna n de la matriz m
(define (elimina-columna n m)
  (if(null? m)
     '()
     (cons (elim-elem 1 n (car m)) (elimina-columna n (cdr m))))) 

; funcion auxiliar para eliminar el elemento n del renglon ren
(define (elim-elem curr n ren)
  (cond ((null? ren) '())
        ((= curr n) (cdr ren))
        (else (cons (car ren) (elim-elem (+ curr 1) n (cdr ren))))))

; 1b - Funcion para agregar el valor n en la posicion pos de la matriz m, ya sea 
; sustituyendo el valor original o agregando los renglones y columnas necesarias
(define (agrega-valor n pos m)
  (agrega-val-ren n m (car pos) (cadr pos) 1 (max (car pos) (length m)) (max (cadr pos) (length (car m)))))

; Funcion auxiliar para recorrer los renglones de la matriz, agregando los nuevos renglones necesarios
; val = valor a insertar en la matriz mat
; ren, col = posicion donde insertar val
; curr = renglon actual
; max-ren y max-col son las dimensiones de la matriz que resultará al final
(define (agrega-val-ren val mat ren col curr max-ren max-col)
  (if (null? mat)
      (cond ((< curr ren) (cons (rellena-ren '() max-col 1) (agrega-val-ren val mat ren col (+ curr 1) max-ren max-col))) 
            ((= curr ren) (cons (agrega-val-col val '() col 1 max-col) (agrega-val-ren val mat ren col (+ curr 1) max-ren max-col)))
            ((<= curr max-ren) (cons (rellena-ren '() max-col 1) (agrega-val-ren val mat ren col (+ curr 1) max-ren max-col)))
            (else '()))
      (cond ((< curr ren) (cons (rellena-ren (car mat) max-col 1) (agrega-val-ren val (cdr mat) ren col (+ curr 1) max-ren max-col))) 
            ((= curr ren) (cons (agrega-val-col val (car mat) col 1 max-col) (agrega-val-ren val (cdr mat) ren col (+ curr 1) max-ren max-col)))
            ((<= curr max-ren) (cons (rellena-ren (car mat) max-col 1) (agrega-val-ren val (cdr mat) ren col (+ curr 1) max-ren max-col)))
            (else '()))))

; Funcion auxiliar para rellenar el renglon ren con 0 para que sea de longitud len
(define (rellena-ren ren len curr)
  (if (>= len curr)
      (if (null? ren)
          (cons '0 (rellena-ren ren len (+ 1 curr)))
          (cons (car ren) (rellena-ren (cdr ren) len (+ 1 curr))))
      '()))

; Funcion auxiliar para insertar val en la posicion pos del renglon ren
; curr = columna actual
; max-col = longitud que debe ser el renglon resultante
(define (agrega-val-col val ren pos curr max-col)
  (if (null? ren)
      (cond ((< curr pos) (cons '0 (agrega-val-col val ren pos (+ 1 curr) max-col)))
            ((= curr pos) (cons val (agrega-val-col val ren pos (+ 1 curr) max-col)))
            ((<= curr max-col) (cons '0 (agrega-val-col val ren pos (+ 1 curr) max-col)))
            (else '()))
      (cond ((< curr pos) (cons (car ren) (agrega-val-col val (cdr ren) pos (+ 1 curr) max-col)))
            ((= curr pos) (cons val (agrega-val-col val (cdr ren) pos (+ 1 curr) max-col)))
            ((<= curr max-col) (cons (car ren) (agrega-val-col val (cdr ren) pos (+ 1 curr) max-col)))
            (else '()))))



; 2a Funcion rango, dado un ABB regresar el rango en formato (min max) donde min es el valor minimo y max es el valor maximo en el ABB
(define (rango abb)
  (if (null? abb) '()
      (list (recorrido-izq abb) (recorrido-der abb))))

(define (recorrido-izq abb) ; funcion visitar nodo izq
  (if (null? (cadr abb))
      (car abb)
      (recorrido-izq (cadr abb))))

(define (recorrido-der abb) ; funcion visitar nodo derecho
  (if (null? (caddr abb))
      (car abb)
      (recorrido-der (caddr abb))))

; 2b Funcion cuenta-nivel, regresar la cantidad de nodos en cierto nivel de un arbol binario
;
; se intuye que el ABB está bien construido
;
(define (cuenta-nivel nivel ABB)
  (if (null? ABB) '()
      (nivel-nivel 0 nivel ABB)))

(define (nivel-nivel act nivel ABB) ; auxiliar para recorrer nivel por nivel
  (cond ((> act nivel) 0)
        ((eq? act nivel)
         (if (null? ABB) 0
             1))
        (else (+ (if (null? (cadr ABB)) 0
                     (nivel-nivel (+ act 1) nivel (cadr ABB)))
                 (if (null? (caddr ABB)) 0
                     (nivel-nivel (+ act 1) nivel (caddr ABB)))))))
    
;SECCION 2
(define g
'((A (B 2) (D 10))
 (B (C 9) (E 5))
 (C (A 12) (D 6))
 (D (E 7))
 (E (C 3))
))

; 3a. Funcion para listar los nodos que tienen al nodo N como origen directo
(define (nodos-destino mat origen)
  ((lambda (nodo)
     (if (null? nodo) '() (map car (cdr nodo)))) ; (cuerpo func lambda) regresa lista del primer elemento de cada adyacencia
   (apply append (map (lambda (x) (if (eq? origen (car x)) x '())) mat)))) ; (argumento func lambda) regresa lista del nodo origen

; 3b. Funcion para eliminar un nodo de un grafo
(define (elimina-nodo grafo nodo)
  (apply append (map (lambda (x) (if (eq? nodo (car x)) '() (list x)))
                     (map (lambda (n) (cons (car n) (apply append (map (lambda (x) (if (eq? (car x) nodo) '() (list x))) (cdr n)))))
                          grafo))))

; Para eliminar el elemento del nodo elim del grafo:
;    (apply append (map (lambda (x) (if (eq? elim (car x)) '() (list x))) grafo))
; Para eliminar las adyacencias hacia el nodo elim en un elemento:
;    (map (lambda (n) (cons (car n) (apply append (map (lambda (x) (if (eq? (car x) elim) '() (list x))) (cdr n))))) g)

