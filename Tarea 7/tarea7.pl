% Adriana Fernánde A01197148
% Luis Angeles A01273884
% Tarea 7

% Funcion que encuentra el n-ésimo elemento de una lista
enesimo(N,[_|R],M) :-
    NAux is N - 1,
    enesimo(NAux, R, MAux),
    M is MAux.
enesimo(1, [P|_], P).

% Funcion que obtiene una lista incremental de numeros entre los valores pasados como argumentos
rango(L, H, R) :-
    L < H,
    LAux is L + 1,
    rango(LAux, H, RAux),
    append([L], RAux, R), !.
rango(L,L,[L]).

cartesianoAux(Elem, [P|R], L) :-
    cartesianoAux(Elem,R,LAux),
    append([[Elem,P]], LAux, L).
cartesianoAux(_,[],[]).

% Funcion que obtiene una lista de pares de elementos del producto cartesiano de dos conjuntos
cartesiano([P1|R1], L2, R) :-
    cartesianoAux(P1,L2,L), !,
    cartesiano(R1, L2, RAux),
    append(L,RAux,R).
cartesiano([],_,[]).

% Funcion que cuenta las veces que aparece un elemento dentro de una lista imbricada
cuenta_profundo(Elem, [[Elem|T]|T2], R) :- % cuando el primer elemento es una lista
    cuenta_profundo(Elem, T, RAux1),
    cuenta_profundo(Elem, T2, RAux2),
    R is RAux1 + RAux2 + 1.
cuenta_profundo(Elem, [[_|T]|T2], R) :-
    cuenta_profundo(Elem, T, RAux1),
    cuenta_profundo(Elem, T2, RAux2), !,
    R is RAux1 + RAux2.

cuenta_profundo(Elem, [Elem|T], R) :- % Cuando el primer elemento no es una lista
    cuenta_profundo(Elem, T, RAux),
    R is RAux + 1.
cuenta_profundo(Elem, [_|T], R) :-
    cuenta_profundo(Elem, T, RAux), !,
    R is RAux.
cuenta_profundo(_,[],0).

% Función lista únicos en Prolog que obtenga una lista con los elementos que no aparecen repetidos dentro de una lista imbricada

lista_unicos_aux([H|T], Prev,[H|R]) :-
    \+ member(H,T),
    \+ member(H,Prev),!,
    lista_unicos_aux(T, Prev,R).
lista_unicos_aux([H|T], Prev, R) :- append(Prev, [H], NewPrev),
    lista_unicos_aux(T, NewPrev, R).
lista_unicos_aux([], _, []).

lista_unicos(L,R) :-
    flatten(L, RAux), 
    lista_unicos_aux(RAux, [],R).
lista_unicos([], []).


% Predicado mayores en Prolog que regrese una lista con los elementos mayores que un valor dado en un árbol binario descrito con la función:
%                               arbol(Raíz, SubárbolIzquierdo, SubárbolDerecho).
arbol(raiz, subarbolIzquierdo, subarbolDerecho).


mayores(Valor, arbol(R, I, D), H):- 
    Valor < R,!,
    mayores(Valor, I, Rizq),
    mayores(Valor, D, Rder),
    append([R|Rizq], Rder, H).
mayores(Valor, arbol(R, _, D), H):- 
    Valor > R,!,
    mayores(Valor, D, H).
mayores(_, nil, []).


% Predicado siembra en Prolog que a partir de una lista de números cree un árbol binario de búsqueda descrito con la función:
%                               arbol(Raíz, SubárbolIzquierdo, SubárbolDerecho).

%inserta un valor al bst
inserta(R, nil, arbol(R,nil, nil)). 
inserta(R, arbol(R2,I,D), arbol(R2,I2,D)):- R=<R2, inserta(R,I,I2).
inserta(R, arbol(R2,I,D), arbol(R2,I,D2)):- R>R2, inserta(R,D,D2).

%auxiliar para manejar los casos
siembra_aux([],nil). /* insert a list of numbers into an empty binary search tree */
siembra_aux([H|T],Arbol):- siembra_aux(T, Temp), inserta(H,Temp,Arbol),!.

%reverse a la lista por recursividad
siembra(L, A):-
    reverse(L, RevL),
    insert_list(RevL, A).