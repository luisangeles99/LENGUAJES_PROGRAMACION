-module(socio).
-export([suscribir_socio/1,elimina_socio/1,lista_existencias/0, crea_pedido/2]).

%matriz() -> 'tienda@MX1219-PF14RYNU'. %compu Adriana
matriz() -> 'tienda@Luiss-Mac-mini'. %compu Luis

% Compradores/Socios
% Metodo de interfaz que le manda un mensaje a la tienda para registrar al socio Socio
% donde la variable Socio es un atomo
suscribir_socio(Socio) -> 
    {tienda, matriz()} ! {self(), suscribir, Socio},
    io:format("~p solicita suscripción de socio ~n", [Socio]),
    receive % espera la respuesta de la tienda de si se pudo suscribir o no
        {ok} -> io:format("Se registro al socio ~p correctamente~n", [Socio]);
        {fail} -> io:format("Ya esta registrado el socio ~p~n", [Socio])
    end.

% Metodo de interfaz que le manda mensaje a la tienda para eliminar al socio Socio
% donde la variable Socio es un atomo
elimina_socio(Socio) ->
    {tienda, matriz()} ! {self(), eliminar, Socio},
    io:format("~p solicita eliminar suscripción de socio ~n", [Socio]),
    receive
        {ok} -> io:format("Se elimino al socio ~p correctamente~n", [Socio])
    end.

% Metodo de interefaz para hacer un pedido, tuplas(producto, cantidad) en una lista
crea_pedido(Socio, ListaDeProductos) ->
    {tienda, matriz()} ! {self(), crearPedido, Socio, ListaDeProductos},
    io:format("~p solicita el siguiente pedido ~p ~n", [Socio, ListaDeProductos]),
    receive
        {failSocio} -> io:format("La orden no pudo ser creada ya que el socio no existe ~p~n", [ListaDeProductos]);
        {failPedido} -> io:format("La orden no pudo ser creada ya que no se cuenta con ninguno de los productos ~p~n", [ListaDeProductos]);
        {Lista} -> io:format("La orden ha sido creada correctamente ~p~n", [Lista])
        
    end.

% Metodo de interfaz para consultar qué productos y la cantidad que hay en existencia de cada uno en la tienda
lista_existencias() -> 
    {tienda, matriz()} ! {self(), existencias},
    io:format("Se solicita la lista de existencias ~n"),
    receive % recibe una lista con la forma [{Nombre,Cant},...]
        {Productos} -> io:format("Productos en existencia: ~p ~n", [Productos])
    end.

%%%%%%% INSTRUCCIONES PARA EJECUTA SOCIO %%%%%%%
%%% Abrir terminal en directorio con archivo tienda, socio
%%% ejecutar erl -sname socio
%%% Verificar que línea 5 matriz tienda@NOMBRECOMPU, NOMBRECOMPU corresponda a la compu que se utiliza
%%% ejecutar c(socio).
%%% Suscrbir socio con socio:suscribir_socio(Socio). ej Socio -> luis
%%% Eliminar socio con socio:elimina_socio(Socio).
%%% crear pedido socio con socio:crea_pedido(SocioExistente, Lista). Lista -> [{helado,10},{pizza,5} .... {elote,10}]
%%% Lista de existencias socio:lista_existencias().
