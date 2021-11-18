-module(tienda).
-export([buscaSocio/2, tienda/4, abre_tienda/0, cierra_tienda/0, lista_socios/0, productos_vendidos/0]).

tienda(Socios, Productos, NumPedido, Pedidos) ->
    receive
        {cerrar} -> 'Bye'; % Termina el proceso de la tienda
        {De, suscribir, Socio} -> % Suscribir un nuevo socio
            case buscaSocio(Socio, Socios) of
                si -> % si ya existe el socio, manda un mensaje de que falló
                    De ! {fail},
                    tienda(Socios, Productos, NumPedido, Pedidos);
                indefinido -> % si no existe, lo agrega a la lista de socios
                    NuevosSocios = lists:append(Socios,[Socio]),
                    De ! {ok},
                    tienda(NuevosSocios, Productos, NumPedido, Pedidos)
            end;
        {De, eliminar, Socio} -> % Eliminar un socio
            NuevosSocios = lists:filter(fun(X) -> X =/= Socio end, Socios), % elimina al socio de la lista de socios, sin verificar si está o no
            De ! {ok},
            tienda(NuevosSocios, Productos, NumPedido, Pedidos);
        {De, existencias} -> % Regresa una lista con los nombres y cantidad de los productos en existencia
            Lista = crearListaExistencias(Productos, []),
            De ! {Lista},
            tienda(Socios, Productos, NumPedido, Pedidos);
        {De, registraProducto, Nombre, Pid} -> % Registrar un nuevo producto
            P = buscaProducto(Nombre, Productos), % Verifica si existe y obtiene el PID del producto
            if
                P == -1 -> % Si no existe, lo agrega a la lista de Productos
                    NuevosProductos = lists:append(Productos, [{Nombre, Pid}]),
                    De ! {ok},
                    tienda(Socios, NuevosProductos, NumPedido, Pedidos);
                true -> % Si ya existe, regresa un mensaje de que no se pudo
                    De ! {fail},
                    tienda(Socios, Productos, NumPedido, Pedidos)
            end;
        {De, eliminarProducto, Producto} -> % Eliminar un producto del registro
            P = buscaProducto(Producto, Productos), % Verifica si existe y obtiene el PID del producto
            if
                P =/= -1 -> % Si existe,
                    P ! {terminar}, % manda un mensaje al proceso del producto para que termine
                    NuevosProductos = lists:filter(fun({X,_}) -> X =/= Producto end, Productos), % lo elimina de la lista de Productos
                    De ! {ok},
                    tienda(Socios, NuevosProductos, NumPedido, Pedidos);
                true -> % Si no existe, regresa un mensaje de que no se pudo
                    De ! {fail},
                    tienda(Socios, Productos, NumPedido, Pedidos)
            end;
        {De, modificarProducto, Producto, Cantidad} -> % Modifica la cantidad de un producto
            P = buscaProducto(Producto, Productos), % Verifica si existe y obtiene el PID del producto
            if
                P =/= -1 -> % Si existe
                    P ! {self(), modificar, Cantidad}, % manda mensaje al producto para que se modifique
                    receive % espera un mensaje de si se logro modificar por esa cantidad
                        {ok} -> De ! {ok};
                        {fail} -> De ! {fail}
                    end;
                true -> % si no existe, regresa un mensaje de que es una operacion invalida
                    De ! {invalido}
            end,
            tienda(Socios, Productos, NumPedido, Pedidos);
        {De, crearPedido, Socio, ListaDeProductos} -> % Crea un pedido si el socio existe y ajusta pedido a productos y cantidades existentes
            case buscaSocio(Socio, Socios) of
                si -> % si el socio existe se procede a crear el pedido
                    PedidoGenerado = crearPedido(Productos, ListaDeProductos, []),
                    LenPedidoGenerado = length(PedidoGenerado),
                    if 
                        LenPedidoGenerado > 0 -> 
                            LenPedidos = length(Pedidos),
                            NuevosPedidos = lists:append(Pedidos, [{LenPedidos, PedidoGenerado}]),
                            De ! {PedidoGenerado},
                            tienda(Socios, Productos, NumPedido, NuevosPedidos);
                        true ->
                            De ! {failPedido}, % no se cuenta con ninguno de los productos del pedido
                            tienda(Socios, Productos, NumPedido, Pedidos)
                    end;
                indefinido -> % si no existe socio el pedido no procede
                    De ! {failSocio},
                    tienda(Socios, Productos, NumPedido, Pedidos)
            end;
        {De, getSocios} -> % regresa la lista de socio
            De ! {Socios},
            tienda(Socios, Productos, NumPedido, Pedidos);
        {De, getPedidos} -> % regresa la lista de pedidos
            De ! {Pedidos},
            tienda(Socios, Productos, NumPedido, Pedidos)
    end.

% Metodo de interfaz
% Registra e inicializa el proceso de la tienda con el alias 'tienda'
abre_tienda() ->
    register(tienda, spawn(?MODULE, tienda, [[], [], 0, []])).

% Metodo de interfaz para terminar el proceso de la tienda
cierra_tienda() -> tienda ! {cerrar}.

% Metodo de interfaz para obtener la lista de todos los socios
lista_socios() -> 
    tienda ! {self(), getSocios},
    receive
        {Socios} -> io:format("Lista de socios: ~p~n", [Socios])
    end.

% Metodo que indica si existe o no un socio en la lista de Socios
buscaSocio(Quien, [Quien|_]) -> 
    si;
buscaSocio(Quien, [_|T]) -> 
    buscaSocio(Quien, T);
buscaSocio(_, _) -> 
    indefinido.

% Metodo que indica si existe o no un producto en la lista de Socios
% y regresa su PID si existe, para que se le puedan mandar mensajes después
buscaProducto(Nombre, [{Nombre, P}|_]) ->
    P;
buscaProducto(Nombre, [_|T]) -> 
    buscaProducto(Nombre, T);
buscaProducto(_, _) -> 
    -1.

% Metodo que crea una lista de la forma [{Nombre, Cantidad}...]
% Con el nombre y la cantidad de todos los productos registrados
crearListaExistencias([{Nom, Pid}|R], Lista) ->
    Pid ! {self(), existencia}, % Le pide al proceso del producto la cantidad que tiene registrada
    receive
        {Cantidad} -> 
            NuevaLista = lists:append(Lista, [{Nom, Cantidad}]),
            crearListaExistencias(R, NuevaLista)
    end;
crearListaExistencias(_, Lista) -> Lista.

%METODO DE INTERFAZ PARA OBTENER LOS PEDIDOS
productos_vendidos() ->
    tienda ! {self(), getPedidos},
    receive
        {Pedidos} -> io:format("Lista de pedidos: ~p~n", [Pedidos])
    end.

% Metodo para crear la lista
crearPedido(Productos, [{Nombre, CantidadPedido}|R], Pedido) ->
    P = buscaProducto(Nombre, Productos),
    if 
        P == -1 -> crearPedido(Productos, R, Pedido);
        true ->
            P ! {self(), existencia},
            receive
                {Cantidad} ->
                    if
                        Cantidad =:= 0 ->
                            crearPedido(Productos, R, Pedido);
                        CantidadPedido =< Cantidad ->
                            P ! {self(), modificar, -CantidadPedido}, % manda mensaje al producto para que se modifique
                                receive % espera un mensaje de si se logro modificar por esa cantidad
                                    {ok} ->
                                        NuevoPedido = lists:append(Pedido, [{Nombre, CantidadPedido}]),
                                        crearPedido(Productos, R, NuevoPedido)
                                end;
                        true -> 
                            P ! {self(), modificar, -Cantidad}, % manda mensaje al producto para que se modifique
                                receive % espera un mensaje de si se logro modificar por esa cantidad
                                    {ok} ->
                                        NuevoPedido = lists:append(Pedido, [{Nombre, Cantidad}]),
                                        crearPedido(Productos, R, NuevoPedido)
                                end
                    end
            end
    end;
crearPedido(_, [], Pedido) -> Pedido.
