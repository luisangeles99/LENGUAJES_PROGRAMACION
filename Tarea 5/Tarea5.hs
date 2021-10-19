-- Adriana Fernández A01197148
-- Luis Angeles A01273884
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

-- ESCTRUCTURAS DE DATOS
data AB t = A (AB t) t (AB t) | V deriving Show
ab = A (A (A V 2 V) 5 (A V 7 V)) 8 (A V 9 (A (A V 11 V) 15 V))

-- 6. Función impares que dado un árbol binario, cree una lista con los valores impares de sus nodos. Recorrer el árbol en preorden al buscar los valores.
impares :: (Integral a) => AB a -> [a]
impares V = []
impares (A l n r) = 
  if (even n) then impares l ++ impares r
  else [n] ++ impares l ++ impares r

-- 7. Función intercambia que dado un árbol binario intercambie los subárboles izquierdos de los nodos con los subárboles derechos.
intercambia :: AB a -> AB a
intercambia V = V
intercambia (A l n r) = A (intercambia r) n (intercambia l)

--FOS y otras facilidades
-- 8. Función recursiva g_distintos que utilizando “guardias” liste los elementos distintos que pertenecen a dos listas. Asumir que los elementos no se repiten dentro de la misma lista.
g_distintos :: (Eq a) => [a] -> [a] ->[a]
g_distintos [] [] = []
g_distintos l1 l2 = (g_l1 l1 l2) ++ (g_l1 l2 l1)

-- auxiliar para g_distintos usando guardias
g_l1 :: (Eq a) => [a] -> [a] -> [a]
g_l1 [] l2 = []
g_l1 (x:r1) l2
  | (x `elem` l2) = g_l1 r1 l2
  | otherwise = [x] ++ g_l1 r1 l2

-- 9. Función no-recursiva c_tabla en Haskell que utilizando “comprensión de listas” obtenga la tabla de multiplicar especificada. Los elementos de la tabla deben aparecer en tuplas. Hasta n*10
c_tabla :: Int -> [((Int, Int), Int)]
c_tabla x = [((n,i), n*i) | n <- [x], i <- [1..10]]

-- 10. Función no-recursiva f_prodpar en Haskell que utilizando la FOS (funciones de orden superior) cree una lista con los productos de los elementos de las listas de tamaño impar.
f_prodpar :: [[Int]] -> [Int]
f_prodpar lista = map product (filter (odd.length) lista)

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
    print "impares"
    print(impares V)                        -- []
    print(impares ab)                       -- [5,7,9,15,11]
    print(impares(A(A(A V 3 V)2 V)1(A(A V 5 V)4 V))) -- [1,3,5]
    print"intercambia"
    --print(intercambia V) --corregir
    print(intercambia ab)
    print(intercambia(A(A(A V 3 V)2 V)1(A(A V 5 V)4 V)))
    print"g_distintos"
    print(g_distintos ['a','b','c'] ['d','f','a']) --corregir
    print(g_distintos [1,2,3] [2,3,1])
    print"c_tabla"
    print(c_tabla 1)
    print(c_tabla 8)
    print"f_prodpar"
    print(f_prodpar [[1,2,3],[4,5],[6,7]])
    print(f_prodpar [[1],[1,2],[1,2,3],[4,3,2]])
