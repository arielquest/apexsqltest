SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<21/08/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Bloqueo según el filtro indicado>
-- ==================================================================================================================================================================================
-- Modificado por:		<16-09-2020><Jose Gabriel Cordero Soto><Se realiza ajuste en resultado final de consulta para obtener información al filtrar por expediente>
-- Modificado por:		<18-12-2020><Jose Gabriel Cordero Soto><Se relaiza ajuste en parametros y se ajusta la consulta por fechas en rango>
-- Modificado por:		<16-07-2021><Roger Lara><Se realiza validacion para que permita consultar expedientes bloqueados en cualquier contexto>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarExpedienteBloqueado]
	@NumeroExpediente			VARCHAR(14) = NULL,
	@UsuarioRed					VARCHAR(30) = NULL,
	@FechaInicio				DATETIME2(3) = NULL,
	@FechaFin					DATETIME2(3) = NULL,
	@CodContexto				VARCHAR(4)  = NULL 
AS
BEGIN
	--Variables
	DECLARE	@L_TC_NumeroExpediente		VARCHAR(14)		 = @NumeroExpediente
	DECLARE	@L_TC_UsuarioRed			VARCHAR(14)		 = @UsuarioRed
	DECLARE	@L_TF_FechaInicio			DATETIME2(3)	 = @FechaInicio
	DECLARE	@L_TF_FechaFin				DATETIME2(3)	 = @FechaFin
	DECLARE @L_TC_CodContexto			VARCHAR(4)		 = @CodContexto

	--Creacion de tabla temporal
	DECLARE @Bloqueos AS TABLE
	(
		Codigo						uniqueidentifier,
		FechaBloqueo				Datetime2(3),
		splitOtros					varchar(20),
		EsExpediente				varchar(1),
		CodigoProceso				smallint,
		DescripcionProceso			varchar(100),
		NumeroExpediente			char(14),
		FechaEntradaExpediente		datetime2(3),
		ContextoExpediente			varchar(4),
		NumeroExpedienteLegajo		char(14),
		CodigoLegajo				uniqueidentifier,		
		FechaEntradaLegajo			datetime2(3),
		ContextoLegajo				varchar(4),
		CodigoAsunto				int,
		DescripcionAsunto			varchar(200),
		UsuarioRed					varchar(30),
		NombreUsuario				varchar(50),
		PrimerApellido				varchar(50), 
		SegundoApellido				varchar(50)
	)
	DECLARE @TemporalBloqueos AS TABLE
	(
		Codigo						uniqueidentifier,
		FechaBloqueo				Datetime2(3),
		splitOtros					varchar(20),
		EsExpediente				varchar(1),
		CodigoProceso				smallint,
		DescripcionProceso			varchar(100),
		NumeroExpediente			char(14),
		FechaEntradaExpediente		datetime2(3),
		ContextoExpediente			varchar(4),
		NumeroExpedienteLegajo		char(14),
		CodigoLegajo				uniqueidentifier,		
		FechaEntradaLegajo			datetime2(3),
		ContextoLegajo				varchar(4),
		CodigoAsunto				int,
		DescripcionAsunto			varchar(200),
		UsuarioRed					varchar(30),
		NombreUsuario				varchar(50),
		PrimerApellido				varchar(50), 
		SegundoApellido				varchar(50)
	)
	
	--Lógica
	INSERT INTO @TemporalBloqueos
	(
		Codigo						,
		FechaBloqueo				,
		splitOtros					,
		EsExpediente				,
		CodigoProceso				,
		DescripcionProceso			,
		NumeroExpediente			,
		FechaEntradaExpediente		,
		ContextoExpediente			,
		NumeroExpedienteLegajo		,
		CodigoLegajo				,	
		FechaEntradaLegajo			,	
		ContextoLegajo				,
		CodigoAsunto				,
		DescripcionAsunto			,
		UsuarioRed					,
		NombreUsuario				,
		PrimerApellido				, 
		SegundoApellido				
	)	
	SELECT		EB.TU_CodBloqueo				AS Codigo,
				EB.TF_FechaBloqueo				AS FechaBloqueo,
				'splitOtros'					AS splitOtros,	
				CASE LEN(ISNULL(ED.TC_NumeroExpediente, ''))
					WHEN 0 THEN '0'
					ELSE '1'
				END								AS EsExpediente,
				P.TN_CodProceso					AS CodigoProceso,
				P.TC_Descripcion				AS DescripcionProceso,
				ED.TC_NumeroExpediente			AS NumeroExpediente,
				ED.TF_Entrada					AS FechaEntradaExpediente,		
				ED.TC_CodContexto				AS ContextoExpediente,
				L.TC_NumeroExpediente			AS NumeroExpedienteLegajo,
				LD.TU_CodLegajo					AS CodigoLegajo,
				LD.TF_Entrada					AS FechaEntradaLegajo,
				LD.TC_CodContexto				AS ContextoLegajo,		
				A.TN_CodAsunto					AS CodigoAsunto,
				A.TC_Descripcion				AS DescripcionAsunto,
				F.TC_UsuarioRed					AS UsuarioRed,
				F.TC_Nombre						AS NombreUsuario,
				F.TC_PrimerApellido				AS PrimerApellido,
				F.TC_SegundoApellido			AS SegundoApellido

	FROM		Expediente.Bloqueo				EB WITH(NOLOCK)
	LEFT JOIN   Expediente.Expediente			E  WITH(NOLOCK)
	ON			E.TC_NumeroExpediente			= EB.TC_NumeroExpediente
	LEFT JOIN   Expediente.ExpedienteDetalle	ED WITH(NOLOCK)
	ON			E.TC_NumeroExpediente			= ED.TC_NumeroExpediente
	LEFT JOIN   Expediente.Legajo				L  WITH(NOLOCK)
	ON			L.TU_CodLegajo					= EB.TU_CodLegajo
	LEFT JOIN	Expediente.LegajoDetalle		LD WITH(NOLOCK)
	ON			LD.TU_CodLegajo					= L.TU_CodLegajo
	INNER JOIN  Catalogo.Funcionario			F  WITH(NOLOCK)
	ON			F.TC_UsuarioRed					= EB.TC_UsuarioRed
	LEFT JOIN	Catalogo.Proceso				P  WITH(NOLOCK)
	ON			P.TN_CodProceso					= ED.TN_CodProceso
	LEFT JOIN	Catalogo.Asunto					A  WITH (NOLOCK)
	ON			A.TN_CodAsunto					= LD.TN_CodAsunto

	WHERE		EB.TC_UsuarioRed				= COALESCE(@L_TC_UsuarioRed, EB.TC_UsuarioRed)	
	AND			EB.TC_CodContexto				= ISNULL(@L_TC_CodContexto,EB.TC_CodContexto)
	
	--Si filtro por expediente no es NULL
	if(@L_TC_NumeroExpediente IS NOT NULL)
		BEGIN	
			IF((SELECT COUNT(Codigo) FROM @TemporalBloqueos WHERE NumeroExpediente = @L_TC_NumeroExpediente) > 0)
			BEGIN				
				INSERT INTO @Bloqueos
				SELECT 
				Codigo						,
				FechaBloqueo				,
				splitOtros					,
				EsExpediente				,
				CodigoProceso				,
				DescripcionProceso			,
				NumeroExpediente			,
				FechaEntradaExpediente		,
				ContextoExpediente			,
				NumeroExpedienteLegajo		,
				CodigoLegajo				,	
				FechaEntradaLegajo			,	
				ContextoLegajo				,
				CodigoAsunto				,
				DescripcionAsunto			,
				UsuarioRed					,
				NombreUsuario				,
				PrimerApellido				, 
				SegundoApellido				
				FROM  @TemporalBloqueos
				WHERE NumeroExpediente = @L_TC_NumeroExpediente
			END

			IF((SELECT COUNT(Codigo) FROM @TemporalBloqueos WHERE NumeroExpedienteLegajo = @L_TC_NumeroExpediente) > 0)
			BEGIN
				INSERT INTO @Bloqueos
				SELECT 
				Codigo						,
				FechaBloqueo				,
				splitOtros					,
				EsExpediente				,
				CodigoProceso				,
				DescripcionProceso			,
				NumeroExpediente			,
				FechaEntradaExpediente		,
				ContextoExpediente			,
				NumeroExpedienteLegajo		,
				CodigoLegajo				,	
				FechaEntradaLegajo			,	
				ContextoLegajo				,
				CodigoAsunto				,
				DescripcionAsunto			,
				UsuarioRed					,
				NombreUsuario				,
				PrimerApellido				, 
				SegundoApellido				
				FROM  @TemporalBloqueos
				WHERE NumeroExpedienteLegajo = @L_TC_NumeroExpediente
			END			
		END
	ELSE 
		BEGIN
			INSERT INTO @Bloqueos
			SELECT 
					Codigo						,
					FechaBloqueo				,
					splitOtros					,
					EsExpediente				,
					CodigoProceso				,
					DescripcionProceso			,
					NumeroExpediente			,
					FechaEntradaExpediente		,
					ContextoExpediente			,
					NumeroExpedienteLegajo		,
					CodigoLegajo				,	
					FechaEntradaLegajo			,	
					ContextoLegajo				,
					CodigoAsunto				,
					DescripcionAsunto			,
					UsuarioRed					,
					NombreUsuario				,
					PrimerApellido				, 
					SegundoApellido				 
			FROM	@TemporalBloqueos 		
		END

	--Si filtro por fecha
	IF(@L_TF_FechaInicio IS NOT NULL AND  @L_TF_FechaFin IS NOT NULL)
	BEGIN 
			 SELECT 
					Codigo						,
					FechaBloqueo				,
					splitOtros					,
					EsExpediente				,
					CodigoProceso				,
					DescripcionProceso			,
					NumeroExpediente			,
					FechaEntradaExpediente		,
					ContextoExpediente			,
					NumeroExpedienteLegajo		,
					CodigoLegajo				,	
					FechaEntradaLegajo			,	
					ContextoLegajo				,
					CodigoAsunto				,
					DescripcionAsunto			,
					UsuarioRed					,
					NombreUsuario				,
					PrimerApellido				, 
					SegundoApellido				 
			FROM     @Bloqueos					A
			WHERE	 convert(varchar(8),A.FechaBloqueo,112)	between convert(varchar(8),@L_TF_FechaInicio,112) and convert(varchar(8),@L_TF_FechaFin,112)
			ORDER BY UsuarioRed, FechaBloqueo
	END
	ELSE 
	BEGIN 
			 SELECT 
					 Codigo						,
					 FechaBloqueo				,
					 splitOtros					,
					 EsExpediente				,
					 CodigoProceso				,
					 DescripcionProceso			,
					 NumeroExpediente			,
					 FechaEntradaExpediente		,
					 ContextoExpediente			,
					 NumeroExpedienteLegajo		,
					 CodigoLegajo				,	
					 FechaEntradaLegajo			,	
					 ContextoLegajo				,
					 CodigoAsunto				,
					 DescripcionAsunto			,
					 UsuarioRed					,
					 NombreUsuario				,
					 PrimerApellido				, 
					 SegundoApellido				 
			FROM     @Bloqueos								
			ORDER BY UsuarioRed, FechaBloqueo
	END
END
GO
