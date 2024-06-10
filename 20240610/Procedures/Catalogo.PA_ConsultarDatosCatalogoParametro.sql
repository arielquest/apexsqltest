SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Isaac Dobles Mata>
-- Fecha de creación:	<19/04/2022>
-- Descripción:			<Permite los datos del catálogo asociado a la configuración recibida por parámetro, SP exclusivo para Encadenamientos>
-- ===========================================================================================================================================================
-- Modificación:		<29/04/2022><Karol Jiménez Sánchez><Se agrega consulta catálogo de Fase, dado que tiene intermedia por tipo Oficina y materia>
-- Modificación:		<10/05/2022><Daniel Ruiz Hernández><Se agrega consulta catálogo de resultado de resolucion, dado que tiene intermedia por materia>
-- Modificación:		<01/06/2022><Karol Jiménez Sánchez><Se ajusta consulta catálogo de resultado de resolucion, dado la intermedia es por tipo de oficina y materia, no sólo por materia>
-- ===========================================================================================================================================================
CREATE      PROCEDURE [Catalogo].[PA_ConsultarDatosCatalogoParametro] 
     @CampoMostrar			VARCHAR(100),
	 @CampoIdentificador	VARCHAR(100),
	 @NombreEstructura		VARCHAR(256),
	 @CodTipoOficina		TINYINT			= NULL,
	 @CodMateria			VARCHAR(5)		= NULL
AS
BEGIN
	
	DECLARE @sql						VARCHAR(MAX),
			@L_CampoMostrar				VARCHAR(100)	= @CampoMostrar,
			@L_CampoIdentificador		VARCHAR(100)	= @CampoIdentificador,
			@L_NombreEstructura			VARCHAR(256)	= @NombreEstructura,
			@L_CodTipoOficina			TINYINT			= @CodTipoOficina,
			@L_CodMateria				VARCHAR(5)		= @CodMateria

	IF @L_CampoIdentificador IS NULL
	BEGIN
		SELECT	@L_CampoIdentificador		= COLUMN_NAME
		FROM	INFORMATION_SCHEMA.COLUMNS
		WHERE	TABLE_NAME					= @L_NombreEstructura
		AND		TABLE_SCHEMA				= 'Catalogo'
		AND		ORDINAL_POSITION			= 1
	END

	IF @L_CampoMostrar is null
	BEGIN
		IF ((SELECT COUNT (*)
			FROM	INFORMATION_SCHEMA.COLUMNS
			WHERE	TABLE_NAME		= @L_NombreEstructura
			and		TABLE_SCHEMA	= 'Catalogo'
			and		COLUMN_NAME		= 'TC_Descripcion') = 0)
		BEGIN
			SET @L_CampoMostrar = 'TC_Descripcion'
		END
		ELSE
		BEGIN
			SELECT	@L_CampoMostrar	=COLUMN_NAME
			FROM	INFORMATION_SCHEMA.COLUMNS
			WHERE	TABLE_NAME				= @L_NombreEstructura
			AND		TABLE_SCHEMA			= 'catalogo'
			AND		ORDINAL_POSITION		= 2
		END
	end

	--Dependiendo de la estructura, se debe de consultar según el tipo de oficina y materia
	IF(@L_NombreEstructura = 'Estado')
	BEGIN
		SET @sql=
		' SELECT		CAST(A.' + @L_CampoIdentificador	+ ' AS VARCHAR(40)) AS Identificador,'+
		'				CAST(A.' + @L_CampoMostrar			+ ' AS VARCHAR(100)) AS Descripcion' +
		' FROM			Catalogo.' + @L_NombreEstructura	+ ' A WITH(NOLOCK)' +
		' INNER JOIN	Catalogo.EstadoTipoOficina	B WITH(NOLOCK)' +
		' ON			A.TN_CodEstado				= B.TN_CodEstado ' +
		' WHERE			A.TF_Inicio_Vigencia		<= GETDATE() ' +
		' AND			(A.TF_Fin_Vigencia			IS NULL OR A.TF_Fin_Vigencia > GETDATE())'+
		' AND			B.TN_CodTipoOficina			= ' + CONVERT(varchar,@L_CodTipoOficina) +
		' AND			B.TC_CodMateria				= '+ '''' + @L_CodMateria + '''' +
		' ORDER	BY		' + @L_CampoMostrar
	END
	ELSE IF(@L_NombreEstructura = 'Fase')
	BEGIN
		SET @sql =
		' SELECT		CAST(A.' + + @L_CampoIdentificador  + ' AS VARCHAR(40)) AS Identificador,'+
		'				CAST(A.' + @L_CampoMostrar			+ ' AS VARCHAR(100)) AS Descripcion' +
		' FROM			Catalogo.' + @L_NombreEstructura	+ ' A WITH(NOLOCK)' +
		' INNER JOIN	Catalogo.MateriaFase				B WITH(NOLOCK)' +
		' ON			A.TN_CodFase						= B.TN_CodFase ' +
		' WHERE			A.TF_Inicio_Vigencia				<= GETDATE() ' +
		' AND			(A.TF_Fin_Vigencia					IS NULL OR A.TF_Fin_Vigencia > GETDATE())'+
		' AND			B.TN_CodTipoOficina					= ' + CONVERT(varchar, @L_CodTipoOficina) +
		' AND			B.TC_CodMateria						= '+ '''' + @L_CodMateria + '''' +
		' ORDER	BY		' + @L_CampoMostrar
	END
	ELSE IF(@L_NombreEstructura = 'TipoResolucion')
	BEGIN
		SET @sql =
		' SELECT		CAST(A.' + + @L_CampoIdentificador  + ' AS VARCHAR(40)) AS Identificador,'+
		'				CAST(A.' + @L_CampoMostrar			+ ' AS VARCHAR(100)) AS Descripcion' +
		' FROM			Catalogo.' + @L_NombreEstructura	+ ' A WITH(NOLOCK)' +
		' INNER JOIN	Catalogo.TipoOficinaTipoResolucion	B WITH(NOLOCK)' +
		' ON			A.TN_CodTipoResolucion				= B.TN_CodTipoResolucion ' +
		' WHERE			A.TF_Inicio_Vigencia				<= GETDATE() ' +
		' AND			(A.TF_Fin_Vigencia					IS NULL OR A.TF_Fin_Vigencia > GETDATE())'+
		' AND			B.TN_CodTipoOficina					= ' + CONVERT(varchar, @L_CodTipoOficina) +
		' AND			B.TC_CodMateria						= '+ '''' + @L_CodMateria + '''' +
		' ORDER	BY		' + @L_CampoMostrar
	END
	ELSE IF(@L_NombreEstructura = 'ResultadoResolucion')
	BEGIN
		SET @sql =
		' SELECT		CAST(A.' + + @L_CampoIdentificador  + ' AS VARCHAR(40)) AS Identificador,'+
		'				CAST(A.' + @L_CampoMostrar			+ ' AS VARCHAR(100)) AS Descripcion' +
		' FROM			Catalogo.' + @L_NombreEstructura	+ ' A WITH(NOLOCK)' +
		' INNER JOIN	Catalogo.TipoOficinaResultadoResolucion		B WITH(NOLOCK)' +
		' ON			A.TN_CodResultadoResolucion				= B.TN_CodResultadoResolucion ' +
		' WHERE			A.TF_Inicio_Vigencia				<= GETDATE() ' +
		' AND			(A.TF_Fin_Vigencia					IS NULL OR A.TF_Fin_Vigencia > GETDATE())'+
		' AND			B.TN_CodTipoOficina					= ' + CONVERT(varchar, @L_CodTipoOficina) +
		' AND			B.TC_CodMateria						= '+ '''' + @L_CodMateria + '''' +
		' ORDER	BY		' + @L_CampoMostrar
	END
	ELSE
	BEGIN
		SET @sql=
		' SELECT	CAST(' + @L_CampoIdentificador  + ' AS VARCHAR(40)) AS Identificador,'+
		'			CAST(' + @L_CampoMostrar		+ ' AS VARCHAR(100)) AS Descripcion' +
		' FROM		Catalogo.' + @L_NombreEstructura	+ ' WITH(NOLOCK)' +
		' WHERE		TF_Inicio_Vigencia	<= GETDATE() ' +
		' AND		(TF_Fin_Vigencia	IS NULL OR TF_Fin_Vigencia > GETDATE())'+
		' ORDER BY	' + @L_CampoMostrar
	END
	EXEC(@sql)
END
GO
