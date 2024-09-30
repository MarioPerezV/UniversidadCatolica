/* -------------------- EVALUACIÓN FINAL -----------------
-- MARIO ALEJANDRO PEREZ VILCHEZ, rut 10.490.153-0
CURSO TELEDUC: Herramientas para la automatización de procesos de bases de datos relacionales con SQL 
(20238_CAP_AUT013N) */

USE Control_Paciente;
/** PROCEDIMIENTOS ALMACENADOS **/
/* Query 1
Crear un procedimiento almacenado que muestre las citas agendadas en un período de tiempo.
Las fechas serán ingresadas por parámetros al momento de llamar al procedimiento almacenado.
Se recomienda utilizar los siguientes datos al llamar el procedimiento: '2020-01-28 10:00:00' 
y '2020-01-29 17:00:00' */
DELIMITER //
CREATE PROCEDURE sp_rango_fecha_hora(IN fecha_hora_ini datetime, IN fecha_hora_fin datetime)
BEGIN
	SELECT * FROM Cita
    WHERE Fecha_Hora BETWEEN fecha_hora_ini AND fecha_hora_fin;
END //
DELIMITER ;
-- Utilizar el procedimiento
CALL sp_rango_fecha_hora('2020-01-28 10:00:00','2020-01-29 17:00:00');


/* Query 2
Crear un procedimiento almacenado que muestre los datos de un paciente, realizando la búsqueda 
mediante uso de parámetros donde se ingresará un rut al momento de llamar al procedimiento.
Complementar datos con la tabla de Comuna para que se pueda visualizar el nombre de la comuna y 
no el ID. */
DELIMITER //
CREATE PROCEDURE sp_paciente(IN p_RUN varchar(13), OUT p_Nombre varchar(50), 
							OUT p_Apellido varchar(80), OUT p_Comuna varchar(20))
BEGIN
    SELECT RUN, Nombre, Apellido, ID_Comuna INTO p_RUN, p_Nombre, p_Apellido, p_Comuna 
    FROM Paciente WHERE RUN = p_RUN;
    SELECT Nombre INTO p_Comuna FROM Comuna WHERE ID = p_Comuna;
END//
DELIMITER ;
CALL sp_paciente('7.808.919-3',@Nombre,@Apellido,@Comuna);
SELECT '7.808.919-3' AS Rut, @Nombre AS Nombre, @Apellido AS Apellido, @Comuna AS Comuna; 


-- //** TRIGGERS **//
/* Query 3
Crear un Trigger que respalde los datos de las citas eliminadas.
Deberá almacenarlos en la tabla Respaldo_Cita.
Eliminar las citas entre los ID 50 y 55 para probar este ejemplo.
Se adjunta los datos que se proponen eliminar:
INSERT Cita(ID,Fecha_Hora,ID_Odontologo,ID_Paciente)
	 VALUES	(50,'2020-02-02 12:00:00',10,21),
			(51,'2020-02-02 12:30:00',10,17),
			(52,'2020-02-02 13:00:00',7,19),
			(53,'2020-02-02 13:30:00',3,23),
			(54,'2020-02-02 14:00:00',8,29),
			(55,'2020-02-02 14:30:00',9,18); */
CREATE TRIGGER Tgr_eliminar_cita AFTER DELETE ON Cita
FOR EACH ROW
	INSERT INTO Respaldo_Cita(ID,Fecha_Hora,ID_Odontologo,ID_Paciente)
		VALUES (OLD.ID, OLD.Fecha_Hora, OLD.ID_Odontologo, OLD.ID_Paciente);        
-- Eliminando Citas
DELETE FROM Cita WHERE ID BETWEEN 50 AND 55;
-- Revisemos que la tabla Respado_Cita contenga efectivamente los datos eliminados
SELECT * FROM Respaldo_Cita;
-- Revisemos que la tabla Cita NO contenga los datos eliminados
SELECT * FROM Cita;


-- //** SENTENCIAS DE CONTROL **//
/* Query 4 
Clasificar utilizando IF, cuál es el descuento que le corresponde
según el valor del presupuesto de la atención dental. 
Sólo se debe mostrar como texto el porcentaje que le corresponderá 
según su tramo.
Si el valor del presupuesto es de $200.000 o más, tendrá un 15% de descuento.
Si el valor del presupuesto es de $70.000 o más, tendrá un 10% de descuento.
Si el valor del presupuesto es de $20.000 o más, tendrá un 5% de descuento.
Resultado considerando como valor 55000
*/
DELIMITER //
CREATE PROCEDURE sp_descuento (IN presupuesto integer)
	BEGIN
		IF presupuesto >= 200000 THEN
			SELECT '15%' AS 'Descuento';
		ELSEIF presupuesto >= 70000 THEN
			SELECT '10%' AS 'Descuento';
		ELSE
			SELECT '5%' AS 'Descuento';
		END IF;
    END//
DELIMITER ;
-- Llamamos al procedimiento considerando como valor 55000
CALL sp_descuento (55000);


/* Query 5 
Clasificar utilizando CASE, a qué turno corresponde la cita del paciente.
Sólo se debe mostrar como texto el turno al que corresponderá según su tramo.
Si la cita es desde las 13:00 hrs (inclusive) en adelante, se deberá clasificar como
 "Turno de tarde".
Si la cita es desde las 09:00 hrs (inclusive) en adelante, se deberá clasificar como
 "Turno de mañana".
** Puede utilizar la función HOUR(<columna>) para extraer sólo la hora de una fecha ** */
SELECT *,
	CASE
		WHEN HOUR(Fecha_Hora) >= '13:00:00' THEN 'Turno Tarde'        
        ELSE 'Turno Mañana'
	END AS Turno
FROM Cita
ORDER BY Fecha_Hora;


/* Query 6 
Realizar un contador en pares utilizando las sentencias LOOP, WHILE o REPEAT.
Con cualquiera de las sentencias de control mencionadas antes,
realizar un contador que comience en 2 y termine en 20.
Debe hacer la numeración de dos en dos. */
DELIMITER //
CREATE PROCEDURE sp_while_contar_hasta_veinte()
	BEGIN
		DECLARE contador INT;
        DECLARE maximo INT;
        DECLARE mensaje TEXT;        
        SET contador = 2;
        SET maximo = 20;
        SET mensaje = contador;        
        WHILE contador < maximo DO
			SET contador = contador + 2;
            SET mensaje = CONCAT(mensaje, ', ', contador);
		END WHILE;        
        SELECT mensaje AS 'resultado_while';
    END//
DELIMITER ;
-- Llamando al procedimiento
CALL sp_while_contar_hasta_veinte();


/** FUNCIONES **/
/* Query 7
Crear una función que permita calcular la edad de una persona utilizando como parámetro una 
fecha de nacimiento que se pueda encontrar disponible en una tabla.
El cálculo que debe hacer la función lo dejo como ejemplo en el siguiente SELECT:
SELECT TRUNCATE((DATEDIFF(CURRENT_DATE, STR_TO_DATE(Fecha_nac, '%Y-%m-%d'))/365.25),0) 
AS Edad
FROM Paciente;
** Es posible que MySQL solicite permisos que se otorgan con la siguiente query:
SET GLOBAL log_bin_trust_function_creators = 1; */
SET GLOBAL log_bin_trust_function_creators = 1;

CREATE FUNCTION f_aplica_edad(Fecha_Nac date)
RETURNS int
   RETURN (DATEDIFF(CURRENT_DATE, STR_TO_DATE(Fecha_Nac, '%Y-%m-%d'))/365.25);
 -- Usamos la Función
SELECT Nombre, f_aplica_edad(Fecha_Nac) AS Edad
FROM Paciente;




