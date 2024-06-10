SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ===========================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jeffry Hernández>
-- Fecha de creación:	<02/05/2018>
-- Descripción:			<Permite los datos del catálogo asociado a la configuración recibida por parámetro>
-- ===========================================================================================================================================================
-- Modificación:		<09/02/2021><Daniel Ruiz Hernández><Se cambian validaciones para consultar catalogos sin indicar el campo a mostrar e identificador>
-- Modificación:		<18/07/2023><Gabriel Arnáez Hodgson><Se agrega validación para el catálogo ResultadoLegajo específicamente.>
-- ===========================================================================================================================================================

CREATE PROCEDURE [Configuracion].[PA_ConsultarDatosCatalogo] 
     @CampoMostrar VARCHAR(100),
	 @CampoIdentificador VARCHAR(100),
	 @NombreEstructura VARCHAR(256)
AS
BEGIN
	
	DECLARE @sql VARCHAR(500)

	IF @CampoIdentificador IS NULL
	BEGIN
		SELECT	@CampoIdentificador			=COLUMN_NAME
		FROM	INFORMATION_SCHEMA.COLUMNS
		WHERE	TABLE_NAME					= @NombreEstructura
		AND		TABLE_SCHEMA				= 'Catalogo'
		AND		ORDINAL_POSITION			= 1
	END

	IF @CampoMostrar is null
	BEGIN
		IF ((SELECT COUNT (*)
			FROM	INFORMATION_SCHEMA.COLUMNS
			WHERE	TABLE_NAME		= @NombreEstructura
			and		TABLE_SCHEMA	= 'Catalogo'
			and		COLUMN_NAME		= 'TC_Descripcion') = 0)
		BEGIN
			SET @CampoMostrar = 'TC_Descripcion'
		END
		ELSE
		BEGIN
			SELECT @CampoMostrar=COLUMN_NAME
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME=@NombreEstructura
			AND TABLE_SCHEMA = 'catalogo'
			AND ORDINAL_POSITION= 2
		END
	end

--Se agrega validación debido a que las columnas TF_FechaInicioVigencia y TF_FechaFinVigencia del catalogo 'ResultadoLegajo'
--no cumplen el estándar para ejecutar la sentencia SQL
	IF (@NombreEstructura = 'ResultadoLegajo')
		BEGIN
			SET @sql=

			' SELECT  CAST(' + @CampoIdentificador  + ' AS VARCHAR(40)) AS Identificador,'+
					 'CAST(' + @CampoMostrar		+ ' AS VARCHAR(100)) AS Descripcion' +

			' FROM Catalogo.' + @NombreEstructura	+ ' WITH(NOLOCK)' +

			' WHERE TF_FechaInicioVigencia <= GETDATE() ' +
			' AND   (TF_FechaFinVigencia IS NULL OR TF_FechaFinVigencia > GETDATE())'+
			' ORDER BY ' + @CampoMostrar
	
			 EXEC(@sql)
		END
	ELSE
		BEGIN
			SET @sql=

			' SELECT  CAST(' + @CampoIdentificador  + ' AS VARCHAR(40)) AS Identificador,'+
					 'CAST(' + @CampoMostrar		+ ' AS VARCHAR(100)) AS Descripcion' +

			' FROM Catalogo.' + @NombreEstructura	+ ' WITH(NOLOCK)' +

			' WHERE TF_Inicio_Vigencia <= GETDATE() ' +
			' AND   (TF_Fin_Vigencia IS NULL OR TF_Fin_Vigencia > GETDATE())'+
			' ORDER BY ' + @CampoMostrar
	
			 EXEC(@sql)
END

END

GO
