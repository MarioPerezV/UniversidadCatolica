USE Empresa;

DELIMITER //
CREATE PROCEDURE sp_rango_sueldo()
BEGIN
	SELECT * FROM Empleado
    WHERE Emp_Sueldo BETWEEN 300000 AND 700000;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_rut_k()
BEGIN
	SELECT * FROM Empleado
    WHERE Emp_Rut LIKE '%k';
END //
DELIMITER ;

show databases;
-- Llamar un procedimiento almacenado
CALL sp_rango_sueldo;
CALL sp_rut_k;

-- Eliminar un procedimiento almacenado
DROP PROCEDURE sp_rango_sueldo;

-- Procedimientos almacenados con el uso de parámetros IN
DELIMITER //
CREATE PROCEDURE sp_rango_fecha(IN fecha_ini date, IN fecha_fin date)
BEGIN
	SELECT * FROM ProductoCliente
    WHERE Pcl_Fecha_Entrega BETWEEN fecha_ini AND fecha_fin;
END //
DELIMITER ;
-- Utilizar el procedimiento
CALL sp_rango_fecha ('2016-06-01','2016-07-31');
CALL sp_rango_fecha ('2016-01-01','2016-07-31');

-- Procedimiento con parametro OUT
DELIMITER //
CREATE PROCEDURE sp_cant_producto (IN ID_Producto integer, OUT Cantidad integer)
BEGIN
	SELECT COUNT(PC1_ID_Prod)
	INTO Cantidad
	FROM ProductoCliente
	WHERE PC1_ID_Prod = ID_Producto;
END //
DELIMITER ;
-- Utilizo el procedimiento
CALL sp_cant_producto(1002,@Cantidad);
SELECT @Cantidad AS "Cantidad de Ventas";

-- Procedimiento con parámetro INOUT
DELIMITER //
CREATE PROCEDURE sp_ventas(INOUT importe integer, IN ID_Producto integer, IN Cantidad integer)
BEGIN
	SELECT (Prd_Precio * Cantidad)
	INTO @precio_total
	FROM Producto
	WHERE Prd_ID = ID_Producto;
    SET importe = importe + @precio_total;
END //
DELIMITER ;
SELECT * FROM Producto; -- Revisamos los productos
-- Valor unitario del refri $238.780
SET @total = 0;
CALL sp_ventas(@total,1005,2);
SELECT @total; -- $477.560

CALL sp_ventas (@total,1005,3);
SELECT @total AS "Total Ventas"; -- $716.340 + $477.560 = $1.193.900








