-module(socio).
-export([suscribir_socio/1,elimina_socio/1,lista_existencias/0, crea_pedido/2]).

%matriz() -> 'tienda@MX1219-PF14RYNU'. %compu Adriana
matriz() -> 'tienda@Luiss-Mac-mini'. %compu Luis

% Compradores/Socios
% Metodo de interfaz que le manda un mensaje a la tienda para registrar al socio Socio
% donde la variable Socio es un atomo
suscribir_socio(Socio) -> 
    {tienda, matriz()} ! {self(), suscribir, Socio},
    receive % espera la respuesta de la tienda de si se pudo suscribir o no
        {ok} -> io:format("Se registro al socio ~p correctamente~n", [Socio]);
        {fail} -> io:format("Ya esta registrado el socio ~p~n", [Socio])
    end.

% Metodo de interfaz que le manda mensaje a la tienda para eliminar al socio Socio
% donde la variable Socio es un atomo
elimina_socio(Socio) ->
    {tienda, matriz()} ! {self(), eliminar, Socio},
    receive
        {ok} -> io:format("Se elimino al socio ~p correctamente~n", [Socio])
    end.

% Metodo de interefaz para hacer un pedido, tuplas(producto, cantidad) en una lista
crea_pedido(Socio, ListaDeProductos) ->
    {tienda, matriz()} ! {self(), crearPedido, Socio, ListaDeProductos},
    receive
        {failSocio} -> io:format("La orden no pudo ser creada ya que el socio no existe ~p ~n", [ListaDeProductos]);
        {failPedido} -> io:format("La orden no pudo ser creada ya que no se cuenta con ninguno de los productos ~p ~n", [ListaDeProductos]);
        {Lista} -> io:format("La orden ha sido creada correctamente ~p ~n", [Lista])
        
    end.

% Metodo de interfaz para consultar qué productos y la cantidad que hay en existencia de cada uno en la tienda
lista_existencias() -> 
    {tienda, matriz()} ! {self(), existencias},
    receive % recibe una lista con la forma [{Nombre,Cant},...]
        {Productos} -> io:format("Productos en existencia: ~p ~n", [Productos])
    end.