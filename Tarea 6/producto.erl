-module(producto).
-export([producto/2, registra_producto/2, elimina_producto/1, modifica_producto/2]).

%matriz() -> 'tienda@MX1219-PF14RYNU'. %compu Adriana
matriz() -> 'tienda@Luiss-Mac-mini'. %compu Luis

% Productos
% Los productos se crean como un proces
% Puede recibir los mensajes: terminar, modificar y existencia
producto(Nombre, Cantidad) ->
    receive
        {terminar} -> % termina el proceso / elimina el producto
            'bye';
        {De, modificar, Dif} -> % aumenta o decrementa la cantidad del producto
            if
                (Cantidad + Dif < 0) -> % Si se quieren quitar mas de los que existen
                    De ! {fail},
                    producto(Nombre, Cantidad);
                true -> % Si se aumentan o si se quitan menos de los que existen
                    NuevaCant = Cantidad + Dif,
                    De ! {ok},
                    producto(Nombre, NuevaCant)
            end;
        {De, existencia} -> % responde con la cantidad de producto que hay
            De ! {Cantidad},
            producto(Nombre, Cantidad)
    end.

% Metodo de interfaz para registrar un producto (con una cantidad inicial)
registra_producto(Producto, Cantidad) when Cantidad >= 0 ->
    P = spawn(?MODULE, producto, [Producto, Cantidad]), % crea el proceso del producto
    {tienda, matriz()} ! {self(), registraProducto, Producto, P}, % llama a la tienda para que lo registre
    receive
        {ok} -> io:format("Se registro el producto ~p correctamente ~n", [Producto]);
        {fail} -> io:format("Ya estaba registrado el producto ~p ~n", [Producto])
    end.

% Metodo de interfaz para eliminar un producto
elimina_producto(Producto) -> 
    {tienda, matriz()} ! {self(), eliminarProducto, Producto}, % llama a la tienda para que lo quite del registro
    receive
        {ok} -> io:format("Se elimino el producto ~p correctamente ~n", [Producto]);
        {fail} -> io:format("No existe el producto ~p ~n", [Producto])
    end.

% Metodo de interfaz para modificar al cantidad en existencia que hay del producto
modifica_producto(Producto, Cantidad) -> 
    {tienda, matriz()} ! {self(), modificarProducto, Producto, Cantidad},
    receive
        {invalido} -> io:format("No existe el producto ~p ~n", [Producto]);
        {ok} -> io:format("Se modifico correctamente el producto ~p ~n", [Producto]);
        {fail} -> io:format("No hay suficiente ~p ~n", [Producto])
    end. 