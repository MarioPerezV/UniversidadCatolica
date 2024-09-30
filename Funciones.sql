/*-------------------------- FUNCIONES --------------------------*/
USE panaderia;
/* Las funciones son realmente útiles cuando es constante la necesidad de relizar algún cálculo
personalizado sin cambiar valores dentro de la tabla.
Se pueden utilizar para visualizar los resultados de la función en un SELECT o dentro de otros 
procesos automatizados más complejos.*/

/*-------------------------- FUNCIÓN SIN PARÁMETROS --------------------------*/
/* Es posible que en MySQL Workbench requiera de permisos para realizar el siguiente contenido.
Para otorgar los permismos basta con ejecutar la siguiente query */

SET GLOBAL log_bin_trust_function_creators = 1;

/* Ejemplo de función sin uso de parámetros que envía un mensaje */
CREATE FUNCTION f_Mensaje() 
RETURNS varchar(20)
    RETURN 'Este es un mensaje';
-- Usamos la función
SELECT f_Mensaje() AS 'Respuesta';


/*-------------------------- FUNCIONES CON PARÁMETROS --------------------------*/
-- Función que aplica IVA al valor que le indiquemos
CREATE FUNCTION f_aplica_iva (valor int)
RETURNS int
   RETURN (valor * 1.19);
 -- Usamos la Función
SELECT Prd_Nombre,Prd_Precio, f_aplica_iva(Prd_precio) AS Precio_c_IVA
FROM Producto;


/* ---------- Función que aplica un descuento que se definirá al momento de usar la función --------*/
CREATE FUNCTION f_aplica_descuento (valor int, descuento int)
RETURNS int
   RETURN valor-(valor*descuento/100);
-- Usamos la Función
SELECT	Prd_Nombre, 
		Prd_Precio AS 'Precio Normal', 
		f_aplica_descuento(Prd_Precio,15) AS 'Dcto 15%',
		f_aplica_descuento(Prd_Precio,30) AS 'Dcto 30%'
FROM Producto;


/* ------- Función que calcula la cantidad de veces que se vendió un producto ----- */
CREATE FUNCTION f_cant_venta (id int)
RETURNS int
	RETURN (SELECT COUNT(pve_prd_id) FROM productoventa WHERE pve_prd_id = id);
-- Usamos la Función
SELECT Prd_Nombre, f_cant_venta(Prd_id) AS Cant_Ventas
FROM Producto
ORDER BY Cant_Ventas DESC;

/*--------- ELIMINACIÓN DE FUNCIONES ------------------*/
DROP FUNCTION xxxx_nnnnnn;




