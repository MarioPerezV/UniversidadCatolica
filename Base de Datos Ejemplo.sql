/* Para este ejercicio realizaremos la creación de una base de datos que contiene 
una serie de tablas especialmente destinadas para este contenido. */

-- Creación de Base de Datos
CREATE DATABASE Ejemplo;

-- Indicamos al servidor la base de datos que usaremos
USE Ejemplo;

-- Creación de tabla Producto
CREATE TABLE Producto
   (ID int NOT NULL AUTO_INCREMENT,  
    Precio int NULL,  
    Nombre varchar(50) NOT NULL,   
    Categoria varchar(50) NULL,
    PRIMARY KEY(ID));

-- Creación de tabla Producto_respaldo
CREATE TABLE Producto_respaldo
   (ID int NOT NULL,  
    Precio int NULL,  
    Nombre varchar(50) NOT NULL,   
    Categoria varchar(50) NULL,
    PRIMARY KEY(ID));    

-- Creación de tabla Producto_eliminado
CREATE TABLE Producto_eliminado
   (ID int NOT NULL,  
    Precio int NULL,  
    Nombre varchar(50) NOT NULL,   
    Categoria varchar(50) NULL,
    PRIMARY KEY(ID));

-- Creación de tabla Producto_actualizado
CREATE TABLE Producto_actualizado
   (ID int NOT NULL,  
    Precio int NULL,  
    Nombre varchar(50) NOT NULL,   
    Categoria varchar(50) NULL,
    Fecha_actualizacion datetime NULL,
    PRIMARY KEY(ID));
    
-- Poblado de datos de la tabla
INSERT INTO Producto(Precio,Nombre,Categoria)
	 VALUES (500,'Alfajor','Pasteleria'),
			(700,'Berlin','Pasteleria'),
			(1350,'Bocado de dama','Panaderia'),
			(800,'Conejo','Pasteleria'),
			(1400,'Dobladita','Panaderia'),
			(500,'Galleton de avena','Pasteleria'),
			(1100,'Hallulla','Panaderia'),
			(1250,'Hallulla Integral','Panaderia'),
			(1100,'Marraqueta','Panaderia'),
			(1250,'Marraqueta Integral','Panaderia'),
			(10990,'Torta','Pasteleria'),
			(990,'Cupcake','Pasteleria'),
			(1190,'Muffin','Pasteleria'),
			(5990,'Kuchen','Pasteleria'),
			(1290,'Galleta Surtidas','Pasteleria'),
			(4500,'Brazo de reina','Pasteleria'),
			(790,'Donas','Pasteleria'),
			(890,'Brownie','Pasteleria'),
			(4990,'Tartaleta','Pasteleria'),
			(790,'Pepsi 1Lts','Refresco'),
			(1250,'Pepsi 2Lts','Refresco'),
			(1890,'Pepsi 3lts','Refresco'),
			(790,'Crush 1Lts','Refresco'),
			(1250,'Crush 2Lts','Refresco'),
			(790,'Kem 1Lts','Refresco'),
			(1250,'Kem 2Lts','Refresco'),
			(790,'Coca-Cola 1,4Lts','Refresco'),
			(1250,'Coca-Cola 2Lts','Refresco'),
			(1590,'Coca-Cola 2,5Lts','Refresco'),
			(1890,'Coca-Cola 3Lts','Refresco'),
			(790,'Fanta 1,4Lts','Refresco'),
			(1250,'Fanta 2Lts','Refresco'),
			(1590,'Fanta 2,5Lts','Refresco'),
			(790,'Sprite 1,4Lts','Refresco'),
			(1250,'Sprite 2Lts','Refresco'),
			(1590,'Sprite 2,5Lts','Refresco'),
			(990,'Andina Del Valle Naranja 1,5Lts','Refresco'),
			(990,'Andina Del Valle Manzana 1,5Lts','Refresco'),
			(990,'Andina Del Valle Damasco 1,5Lts','Refresco'),
			(990,'Andina Del Valle Durazano 1,5Lts','Refresco'),
			(790,'Aquarius Uva 1Lts','Refresco'),
			(790,'Aquarius Pera 1Lts','Refresco'),
			(790,'Aquarius Manzana 1Lts','Refresco');
