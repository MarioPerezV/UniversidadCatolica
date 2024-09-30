USE Empresa;

/*Este primer procedimiento almacenado permite la selección de todos los empleados con sueldos entre 200.000 y 600.000.*/

/*El DELIMITER es un delimitador para indicar a MySQL que se trata de un bloque independiente. 
En los ejemplos que veremos a continuación esta instrucción frena la ejecución de MySQL que select
reactivará luego del DELIMITER final */

DELIMITER // 
CREATE PROCEDURE sp_rango_sueldo()
BEGIN
	SELECT * FROM Empleado
    WHERE Emp_Sueldo BETWEEN 200000 AND 600000;
END//
DELIMITER ;

/*Otro ejemplo de un procedimiento almacenado sencillo es la búsqueda de los empleados con rut terminado en K*/
DELIMITER // 
CREATE PROCEDURE sp_rut_k()
BEGIN
	SELECT * FROM Empleado
    WHERE Emp_Rut LIKE '%k';
END//
DELIMITER ;
/* -------------------------- LLAMAR UN PROCEDIMIENTO ALMACENADO -------------------------- */
/*Para llamar o ejecutar un procedimiento almacenado existente en la base de datos se hace con la instrucción CALL*/
CALL sp_rango_sueldo;
CALL sp_rut_k;

/*Para eliminar un procedimiento almacenado se realiza con la instricción DROP PROCEDURE*/
DROP PROCEDURE sp_rut_k;

/*En MySQL no permite la edición de procedimientos almacenados a diferencia de otros gestores de bases de datos.
Para corregirlos se debe eliminar y volver a crear con los cambios esperados.*/

DROP PROCEDURE sp_rango_sueldo;

DELIMITER // 
CREATE PROCEDURE sp_rango_sueldo()
BEGIN
	SELECT Emp_Nombre, Emp_Apellido, Emp_Sueldo
    FROM Empleado
    WHERE Emp_Sueldo BETWEEN 200000 AND 600000;
END//
DELIMITER ;

/* -------------------------- PROCEDIMIENTO ALMACENADO CON USO DE PARÁMETROS -------------------------- */

/*La creación de procedimientos almacenados con uso de parámetros es bastante parecida a los ejemplos anteriores
Salvo que en este caso los parámetros ayudan a crear procedimientos almacenados que sean dinámicos en cuanto a los criterios de
búsqueda.
Pero primero que todo debemos saber que en MySQL existen tres maneras de definir los parámetros, IN, OUT e INOUT.
A continuación mostraré ejemplos de cada uno*/

/* -------------------------- PARÁMETROS IN -------------------------- */

/*Los parametros definidos como IN*/
/*Este procedimiento realizará la búsqueda de las ventas realizadas entre dos fechas, 
estas fechas las solicitaremos*/
DELIMITER //
CREATE PROCEDURE SP_Rango_Fecha (IN fecha_ini date, IN fecha_fin date)
BEGIN
	SELECT *
	FROM ProductoCliente
	WHERE Pcl_Fecha_Entrega BETWEEN fecha_ini AND fecha_fin;
END//
DELIMITER ;
-- Utilizar el procedimiento
CALL SP_Rango_Fecha ('2016-06-01','2016-07-31');
CALL SP_Rango_Fecha ('2016-01-01','2016-07-31');

/* -------------------------- PARÁMETROS OUT -------------------------- */

/*Procedimiento definiendo con OUT*/
/*Se utilizará un IN para entregar un dato y un OUT para obtener otro*/
DELIMITER //
CREATE PROCEDURE SP_Cant_Producto (IN ID_Producto integer, OUT Cantidad integer)
BEGIN
	SELECT COUNT(Pcl_ID_Prod)
    INTO Cantidad
    FROM ProductoCliente
    WHERE Pcl_ID_Prod = ID_Producto;
END//
DELIMITER ;

CALL SP_Cant_Producto (1002, @Cantidad);
SELECT @Cantidad AS Cant_Ventas;

select * from productocliente;

/* -------------------------- PARÁMETROS INOUT -------------------------- */

/*Procedimiento almacenado con INOUT*/
/*Se descontará un valor del precio del producto con INOUT para que mantenga su valor después de ejecutar el procedimiento.*/
DELIMITER //
CREATE PROCEDURE SP_Ventas(INOUT importe integer, IN ID_Producto integer, IN Cantidad integer)
BEGIN
	SELECT (Prd_Precio * Cantidad)
    INTO @precio_total
    FROM Producto
    WHERE Prd_ID = ID_Producto;
    SET importe = importe + @precio_total;
END//
DELIMITER ;
/*
Valor unitario del refrigerador es de $238.780
En el primer ejemplo se venden 2 lo que da un resultado de $477.560
*/
SET @total = 0;
CALL SP_Ventas(@total, 1005, 2);
SELECT @total AS "Total Ventas";
-- 477.560
/* En el segundo ejemplo se venden 3 lo que da un resultado de $716.340
sumando el valor anterior que el parametro INOUT mantiene en memoria
da un resultado de $1.193.900
*/
CALL SP_Ventas(@total, 1005, 3);
SELECT @total AS "Total Ventas";
-- 1.193.900

/* -------------------------- OTROS EJEMPLOS -------------------------- */

/*
Ejemplo de procedimiento almacenado que hace la búsqueda de los datos de un cliente
Complementando datos con la tabla de Comuna. Buscando por un rut utilizando parametros
*/
DELIMITER //
CREATE PROCEDURE SP_Datos_Cliente (IN rut varchar(15))
BEGIN
	SELECT	Cli_Rut AS Rut,
			Cli_Nombre AS Nombre,
            Cli_Apellido AS Apellido,
            Com_Nombre AS Comuna
    FROM Cliente
    LEFT JOIN Comuna
    ON Cli_ID_Comuna = Com_ID
    WHERE Cli_Rut = rut;
END//
DELIMITER ;

CALL SP_Datos_Cliente ('6.324.328-7');

/*
Procedimiento almacenado que permite modificar el nombre de un producto
*/
DELIMITER //
CREATE PROCEDURE SP_Modifica_Producto(IN ID_Producto int, Nombre_Producto varchar(20))
BEGIN
	UPDATE Producto
	SET Prd_Nombre = Nombre_Producto
	WHERE Prd_ID = ID_Producto;
	SELECT * FROM Producto
	WHERE Prd_ID = ID_Producto;
END //
DELIMITER ;

CALL SP_Modifica_Producto (1001,'BluRay');