% Adriana Fernánde A01197148
%
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