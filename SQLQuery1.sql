CREATE TABLE ciudad(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL
);

CREATE TABLE farmaceutico(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	fk_ciudad INT,
	FOREIGN KEY (fk_ciudad) REFERENCES ciudad(id)
);

CREATE TABLE farmacia(
	id INT PRIMARY KEY NOT NULL,
	clave VARCHAR(10) NOT NULL,
	fk_ciudad INT,
	fk_farmaceutico INT,
	FOREIGN KEY (fk_ciudad) REFERENCES ciudad(id),
	FOREIGN KEY (fk_farmaceutico) REFERENCES farmaceutico(id)
);

CREATE TABLE empleados(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(40) NOT NULL,
	fk_farmacia INT,
	FOREIGN KEY (fk_farmacia) REFERENCES farmacia(id)
);

CREATE TABLE medicamentos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(30) NOT NULL,
	presentacion VARCHAR(20),
	componentes VARCHAR(20),
	laboratorio VARCHAR(20),
	accion VARCHAR(20),
	precio INT NOT NULL
);

CREATE TABLE stock(
	fk_farmacia INT,
	fk_medicamento INT,
	cantidad INT,
	FOREIGN KEY (fk_farmacia) REFERENCES farmacia(id),
	FOREIGN KEY (fk_medicamento) REFERENCES medicamentos(id)
);

INSERT INTO ciudad(nombre)
VALUES('Iquique');

INSERT INTO ciudad(nombre)
VALUES('Arica');

INSERT INTO ciudad(nombre)
VALUES('Antofagasta');

INSERT INTO ciudad(nombre)
VALUES('Alto Hospicio');

INSERT INTO farmaceutico(nombre,descripcion,fk_ciudad)
VALUES('Juan Perez','Experto en X',1);

INSERT INTO farmaceutico(nombre,descripcion,fk_ciudad)
VALUES('Gonzalo Gonzalez','Experto en Y',1);

INSERT INTO farmaceutico(nombre,descripcion,fk_ciudad)
VALUES('Ramiro Ramirez','Experto en Z',2);

INSERT INTO farmaceutico(nombre,descripcion,fk_ciudad)
VALUES('Elmis Mísimo','Experto en A',3);

INSERT INTO farmacia
VALUES(1111,'clave1',1,1);

INSERT INTO farmacia
VALUES(2222,'clave2',2,2);

INSERT INTO farmacia
VALUES(3333,'clave3',2,2);

INSERT INTO farmacia
VALUES(4444,'clave4',3,3);



CREATE OR ALTER PROCEDURE comprobar
@id INT,
@clave VARCHAR(10),
@respuesta INT OUT
AS
BEGIN
	IF(EXISTS(SELECT * FROM farmacia WHERE id=@id AND clave=@clave))
	BEGIN
		SET @respuesta=1;	
	END
	ELSE
	BEGIN
		SET @respuesta=0;
	END
END

CREATE OR ALTER PROCEDURE revisar
	@id INT,
	@verificar INT OUT
AS
BEGIN
	IF(EXISTS(SELECT id FROM medicamentos WHERE id=@id))
	BEGIN
		SET @verificar=1;
	END
	ELSE
	BEGIN
		SET @verificar=0;
	END
END

CREATE OR ALTER PROCEDURE eliminar
	@id INT
AS
BEGIN
	DELETE FROM stock WHERE fk_medicamento=@id;
	DELETE FROm medicamentos WHERE id=@id;
END


CREATE OR ALTER PROCEDURE agregar
	@nombre VARCHAR(30),
	@presentacion VARCHAR(20),
	@componentes VARCHAR(20),
	@accion VARCHAR(20),
	@cantidad INT,
	@precio INT,
	@laboratorio VARCHAR(20),
	@farmacia INT
AS
BEGIN
	INSERT INTO medicamentos(nombre,presentacion,componentes,laboratorio,accion,precio)
	VALUES(@nombre,@presentacion,@componentes,@laboratorio,@accion,@precio);
	INSERT INTO stock(fk_farmacia,fk_medicamento,cantidad)
	VALUES(@farmacia,(SELECT id FROM medicamentos WHERE nombre=@nombre),@cantidad);
END

