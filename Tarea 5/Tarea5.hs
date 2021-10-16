-- Adriana Fernández A01197148
--
-- Tarea 5

-- PROGRAMACIÓN BÁSICA Y RECURSIVA SIN LISTAS
-- 1. Funcion para promediar el valor mayor y menor en una función de 4 argumentos
medio :: Float -> Float -> Float -> Float -> Float
medio a b c d = (menor (menor a b) (menor c d) + mayor (mayor a b) (mayor c d)) / 2

-- Función auxiliar que regresa el menor de dos numeros
menor :: Float -> Float -> Float
menor a b = if a < b then a else b

-- Función auxiliar que regresa el mayor de dos numeros
mayor :: Float -> Float -> Float
mayor a b = if a < b then b else a

-- 2. Función para contar la cantidad de números primos que existen en el rango definido por los argumentos
primos :: Int -> Int -> Int
primos inf sup
    | inf > sup =  0
    | primo inf 2 = 1 + primos (inf + 1) sup
    | otherwise = primos (inf + 1) sup

-- Funcion auxiliar para determinar si un numero es primo
primo :: Int -> Int -> Bool
primo n r
    | n == 1 = False
    | sqrt (fromIntegral n) < fromIntegral r = True
    | mod n r == 0 = False
    | otherwise = primo n (r + 1)

-- LISTAS Y EMPATAMIENTO DE PATRONES
-- 3. Función que compara los elementos de dos listas del mismo tamaño para regresar una lista que indique en cuál se encuentra el mayor de cada posicion
mayores :: [Int] -> [Int] -> [Int]
mayores [] [] = []
mayores (p1:r1) (p2:r2)
    | p1 > p2 = 1:mayores r1 r2
    | p2 > p1 = 2:mayores r1 r2
    | otherwise = 1:mayores r1 r2

-- 4. Función que obtiene una lista de 1’s que representa el resultado en unario de multiplicar dos enteros no negativos en unario
multiplica :: [Int] -> [Int] -> [Int]
multiplica [] _ = []
multiplica (p:resto) lista = lista ++ multiplica resto lista

-- 5. Función que reciba una lista de cualquier tamaño y un entero no negativo N, y regrese la misma lista a la cual se le han aplicado N desplazamientos circulares hacia la derecha.
desplaza :: [Int] -> Int -> [Int]
desplaza l 0 = l
desplaza lista n = desplaza (last lista : init lista) (n - 1)
-- desplaza lista n = desplaza (last lista : reverse (tail (reverse lista))) (n-1)

main = do
    print "medio:"
    print(medio 2 1 5 4)                    -- 3
    print(medio 2 2 2 2)                    -- 2
    print "primos:"
    print(primos 1 10)                      -- 4
    print(primos 5 11)                      -- 3
    print(primos 8 10)                      -- 0
    print "mayores:"
    print (mayores [8,5,2,4] [1,2,3,4])     -- [1,1,2,1]
    print (mayores [1,2,3] [2,3,1])         -- [2,2,1]
    print "multiplica"
    print (multiplica [1,1] [1,1,1])        -- [1,1,1,1,1,1]
    print (multiplica [1,1,1] [])           -- []
    print (multiplica [1,1,1,1] [1,1])      -- [1,1,1,1,1,1,1,1]
    print "desplaza"
    print(desplaza [1,2,3] 1)               -- [3,1,2]
    print(desplaza [1,2,3] 2)               -- [2,3,1]
    print(desplaza [1,2,3] 6)               -- [1,2,3]