------------
-- tablas --
------------
CREATE TABLE EMPLEADOS (
	EMPLEADO_ID INT NOT NULL PRIMARY KEY IDENTITY,
	APELLIDOS VARCHAR(100) NOT NULL,
	NOMBRE VARCHAR(60) NOT NULL,
	DNI CHAR(8) NOT NULL UNIQUE,
	GENERO VARCHAR(30) NOT NULL,
	ESTADO_CIVIL VARCHAR(30) NOT NULL,
	DIRECCION VARCHAR(300) NOT NULL,
	DISTRITO_ID VARCHAR(7) NOT NULL,
	ESTADO INT DEFAULT '1'
)
GO

CREATE TABLE TELEFONOS (
	TELEFONO_ID INT NOT NULL PRIMARY KEY IDENTITY,
	OPERADOR VARCHAR(50) NOT NULL,
	NUMERO VARCHAR(9) NOT NULL UNIQUE,
	EMPLEADO_ID INT NOT NULL,
	ESTADO INT DEFAULT '1'
)
GO

--------------------------------
-- procedimientos almacenados --
--------------------------------

CREATE PROCEDURE SP_LISTAR_DEPARTAMENTOS
AS
BEGIN
	SELECT * FROM DEPARTAMENTOS
END
GO

CREATE PROCEDURE SP_LISTAR_PROVINCIAS
	@DEPARTAMENTO_ID VARCHAR(7)
AS
BEGIN
	SELECT * FROM PROVINCIAS WHERE DEPARTAMENTO_ID = @DEPARTAMENTO_ID
END
GO

CREATE PROCEDURE SP_LISTAR_DISTRITOS
	@PROVINCIA_ID VARCHAR(7)
AS
BEGIN
	SELECT * FROM DISTRITOS WHERE PROVINCIA_ID = @PROVINCIA_ID
END
GO

CREATE PROCEDURE SP_REGISTRAR_EMPLEADO
	@APELLIDOS VARCHAR(100),
	@NOMBRE VARCHAR(60),
	@DNI CHAR(8),
	@GENERO VARCHAR(30),
	@ESTADO_CIVIL VARCHAR(30),
	@DIRECCION VARCHAR(300),
	@DISTRITO_ID VARCHAR(7),
	@ULTIMO_ID INT OUTPUT
AS
BEGIN
	INSERT INTO EMPLEADOS
		(APELLIDOS, NOMBRE, DNI, GENERO, DIRECCION, ESTADO_CIVIL, DISTRITO_ID)
	VALUES
		(@APELLIDOS,@NOMBRE,@DNI,@GENERO,@DIRECCION,@ESTADO_CIVIL,@DISTRITO_ID)
	SET
		@ULTIMO_ID = SCOPE_IDENTITY()
	RETURN
		@ULTIMO_ID
END
GO

CREATE PROCEDURE SP_REGISTRAR_TELEFONO
	@OPERADOR VARCHAR(50),
	@NUMERO VARCHAR(9),
	@EMPLEADO_ID INT
AS
BEGIN
	INSERT INTO TELEFONOS
		(OPERADOR, NUMERO, EMPLEADO_ID)
	VALUES
		(@OPERADOR, @NUMERO, @EMPLEADO_ID)
END
GO

CREATE PROCEDURE SP_LISTAR_EMPLEADOS
AS
BEGIN
	SELECT
		E.EMPLEADO_ID, E.APELLIDOS, E.NOMBRE, E.DNI, E.GENERO, D.NOMBRE_DISTRITO
	FROM
		EMPLEADOS E
	INNER JOIN DISTRITOS D ON E.DISTRITO_ID = D.DISTRITO_ID
END
GO

CREATE PROCEDURE SP_LISTAR_EMPLEADOS_POR_NOMBRE
	@NOMBRE VARCHAR(60)
AS
BEGIN
	SELECT
		E.EMPLEADO_ID, E.APELLIDOS, E.NOMBRE, E.DNI, E.GENERO, D.NOMBRE_DISTRITO
	FROM
		EMPLEADOS E
	INNER JOIN
		DISTRITOS D ON E.DISTRITO_ID = D.DISTRITO_ID
	WHERE
		NOMBRE LIKE '%'+@NOMBRE+'%'
END
GO

CREATE PROC SP_BUSCAR_EMPLEADO_POR_ID
	@ID INT
AS
BEGIN
	SELECT
		EMPLEADO_ID, APELLIDOS, NOMBRE, DNI, GENERO, ESTADO_CIVIL, DIRECCION, E.DISTRITO_ID, P.PROVINCIA_ID, DP.DEPARTAMENTO_ID
	FROM
		EMPLEADOS E
	INNER JOIN
		DISTRITOS D ON E.DISTRITO_ID = D.DISTRITO_ID
	INNER JOIN
		PROVINCIAS P ON D.PROVINCIA_ID = P.PROVINCIA_ID
	INNER JOIN
		DEPARTAMENTOS DP ON P.DEPARTAMENTO_ID = DP.DEPARTAMENTO_ID
	WHERE
		EMPLEADO_ID = @ID
END
GO

CREATE PROC SP_BUSCAR_TELEFONO_POR_EMPLEADO_ID
	@EMPLEADO_ID INT
AS
BEGIN
	SELECT
		*
	FROM
		TELEFONOS
	WHERE
		EMPLEADO_ID = @EMPLEADO_ID
END
GO

CREATE PROCEDURE SP_ACTUALIZAR_EMPLEADO
	@APELLIDOS VARCHAR(100),
	@NOMBRE VARCHAR(60),
	@DNI CHAR(8),
	@GENERO VARCHAR(30),
	@ESTADO_CIVIL VARCHAR(30),
	@DIRECCION VARCHAR(300),
	@DISTRITO_ID VARCHAR(7),
	@EMPLEADO_ID INT
AS
BEGIN
	UPDATE
		EMPLEADOS
	SET
		APELLIDOS = @APELLIDOS,
		NOMBRE = @NOMBRE,
		DNI = @DNI,
		GENERO = @GENERO,
		ESTADO_CIVIL = @ESTADO_CIVIL,
		DIRECCION = @DIRECCION,
		DISTRITO_ID = @DISTRITO_ID
	WHERE
		EMPLEADO_ID = @EMPLEADO_ID
END
GO

CREATE PROC SP_ELIMINAR_TELEFONO
	@TELEFONO_ID INT
AS
BEGIN
	DELETE
	FROM
		TELEFONOS
	WHERE
		TELEFONO_ID = @TELEFONO_ID
END
GO

CREATE PROC SP_ELIMINAR_EMPLEADO
	@EMPLEADO_ID INT
AS
BEGIN
	DELETE
	FROM
		EMPLEADOS
	WHERE
		EMPLEADO_ID = @EMPLEADO_ID
END
GO