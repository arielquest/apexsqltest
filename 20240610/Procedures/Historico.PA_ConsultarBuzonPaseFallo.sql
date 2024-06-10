SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Versión:				<1.0>  
-- Creado por:			<Jose Miguel Avendaño Rosales>
-- Fecha de creación:	<13/07/2021>
-- Descripción:			<Obtiene la informacion del historico de pase a fallo para la consulta de buzón según los parámetros establecidos.>
-- =========================================================================================================================================
-- Modificación:		<27/07/2021> <Aida Elena Siles R> <Se agrega el proceso del expediente y del legajo.>
-- Modificacion:		<30/08/2021> <Jose Miguel Avendaño R> <Se modificar el ordenamiento de expediente a fecha de vencimiento>
-- Modificacion:		<14/09/2021> <Jose Miguel Avendaño R> <Se modifica para que no de error en los casos en que el funcionario tiene nombres y apellidos
--										de 50 caracteres cada uno>
-- =========================================================================================================================================
-- Modificación:		<04/08/2022> <Rafa Badilla Alvarado> <Mostrar los registros pase a fallo con puesto de trabajo sin funcionario asignado.>
-- =========================================================================================================================================
CREATE   PROCEDURE [Historico].[PA_ConsultarBuzonPaseFallo]
	@NumeroExpediente		CHAR(14)		= NULL,  
	@Contexto				VARCHAR(4)		= NULL,
	@FechaDesdePaseFallo	DATETIME		= NULL,
	@FechaHastaPaseFallo	DATETIME		= NULL,
	@FechaDesdeDevolucion	DATETIME		= NULL,
	@FechaHastaDevolucion	DATETIME		= NULL,
	@FechaDesdeVencimiento	DATETIME		= NULL,
	@FechaHastaVencimiento	DATETIME		= NULL,
	@FechaDesdeResolucion	DATETIME		= NULL,
	@FechaHastaResolucion	DATETIME		= NULL,
	@PersonaAsignada		VARCHAR(155)	= NULL,
	@PersonaRedacta			VARCHAR(155)	= NULL,
	@NumeroPagina			INT,  
	@CantidadRegistros		INT,
	@CargaInicial			BIT				= 'False'
AS
BEGIN 
	DECLARE		@L_NumeroExpediente			AS CHAR(14)		= @NumeroExpediente
	DECLARE		@L_Contexto					AS VARCHAR(4)	= @Contexto
	DECLARE		@L_FechaDesdePaseFallo		AS DATETIME		= @FechaDesdePaseFallo
	DECLARE		@L_FechaHastaPaseFallo		AS DATETIME		= @FechaHastaPaseFallo
	DECLARE		@L_FechaDesdeDevolucion		AS DATETIME		= @FechaDesdeDevolucion
	DECLARE		@L_FechaHastaDevolucion		AS DATETIME		= @FechaHastaDevolucion
	DECLARE		@L_FechaDesdeVencimiento	AS DATETIME		= @FechaDesdeVencimiento
	DECLARE		@L_FechaHastaVencimiento	AS DATETIME		= @FechaHastaVencimiento
	DECLARE		@L_FechaDesdeResolucion		AS DATETIME		= @FechaDesdeResolucion
	DECLARE		@L_FechaHastaResolucion		AS DATETIME		= @FechaHastaResolucion
	DECLARE		@L_PersonaAsignada			AS VARCHAR(155)	= @PersonaAsignada
	DECLARE		@L_PersonaRedacta			AS VARCHAR(155)	= @PersonaRedacta
	DECLARE		@L_NumeroPagina				AS INT			= @NumeroPagina
	DECLARE		@L_CantidadRegistros		AS INT			= @CantidadRegistros
	DECLARE		@L_CargaInicial				AS BIT			= @CargaInicial;

	DECLARE @Result TABLE 
	(
		NumeroExpediente				CHAR(14),					
		NombrePersonaAsignada			VARCHAR(155),		
		ExpedienteAsunto				VARCHAR(255),
		CodigoClase						INT,					
		DescripcionClase				VARCHAR(255),		
		CodigoPaseFallo					UNIQUEIDENTIFIER,				
		FechaAsignacion					DATETIME2(3),					
		FechaVencimiento				DATETIME2(3),			
		FechaDevolucion					DATETIME2(3),
		DescripcionExpOLeg				VARCHAR(255),
		FechaResolucion					DATETIME2(3),
		NombrePersonaRedacta			VARCHAR(155),
		CodigoLegajo					UNIQUEIDENTIFIER,
		CodigoProcesoExp				SMALLINT,
		CodigoProcesoLeg				SMALLINT,
		DescripcionProceso				VARCHAR(100),
		HorasPendientes					INT,
		CodMotivoDevolucion				SMALLINT,
		MotivoDevolucion				VARCHAR(150)
	)
	
	INSERT INTO @Result 
				(
					NumeroExpediente				,					
					NombrePersonaAsignada			,		
					ExpedienteAsunto				,
					CodigoClase						,					
					DescripcionClase				,		
					CodigoPaseFallo					,				
					FechaAsignacion					,					
					FechaVencimiento				,			
					FechaDevolucion					,
					DescripcionExpOLeg				,
					FechaResolucion					,
					NombrePersonaRedacta			,
					CodigoLegajo					,
					CodigoProcesoExp				,
					CodigoProcesoLeg				,
					DescripcionProceso				,
					HorasPendientes					,
					CodMotivoDevolucion				,
					MotivoDevolucion
				)
	SELECT		A.TC_NumeroExpediente				AS NumeroExpediente,
				CONCAT(G.TC_Nombre, ' ', G.TC_PrimerApellido, ' ', G.TC_SegundoApellido) AS NombrePersonaAsignada,
				'Expediente'						AS ExpedienteAsunto,
				D.TN_CodClase						AS Codigo,
				D.TC_Descripcion					AS Descripcion,
				A.TU_CodPaseFallo					AS CodigoPaseFallo,
				A.TF_FechaAsignacion				AS FechaAsignacion,
				A.TF_FechaVencimiento				AS FechaVencimiento,
				A.TF_FechaDevolucion				AS FechaDevolucion,
				B.TC_Descripcion					AS Descripcion,
				H.TF_FechaResolucion				AS FechaResolucion,
				CONCAT(J.TC_Nombre, ' ', J.TC_PrimerApellido, ' ', J.TC_SegundoApellido) AS NombrePersonaRedacta,
				A.TU_CodLegajo						AS CodigoLegajo,
				C.TN_CodProceso						AS CodigoProcesoExp,
				NULL,
				K.TC_Descripcion					AS DescripcionProceso,
				(SELECT Expediente.FN_HorasPendientesFechaVence (@L_Contexto, A.TF_FechaVencimiento)) AS HorasPendientes,
				A.TN_CodMotivoDevolucion			AS CodMotivoDevolucion,
				M.TC_Descripcion					AS MotivoDevolucion
	FROM		Historico.PaseFallo					AS A WITH(NOLOCK)
	INNER JOIN	Expediente.Expediente				AS B WITH(NOLOCK)
	ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente
	AND			A.TF_FechaAsignacion				>= Coalesce(@L_FechaDesdePaseFallo, A.TF_FechaAsignacion)
	AND			A.TF_FechaAsignacion				<= Coalesce(@L_FechaHastaPaseFallo, A.TF_FechaAsignacion)
	AND			A.TF_FechaVencimiento				>= Coalesce(@L_FechaDesdeVencimiento, A.TF_FechaVencimiento)
	AND			A.TF_FechaVencimiento				<= Coalesce(@L_FechaHastaVencimiento, A.TF_FechaVencimiento)
	AND			A.TC_NumeroExpediente				= Coalesce(@L_NumeroExpediente, A.TC_NumeroExpediente)
	AND			A.TC_CodContexto					= Coalesce(@L_Contexto, A.TC_CodContexto)
	AND			A.TU_CodLegajo						Is NULL
	INNER JOIN	Expediente.ExpedienteDetalle		AS C WITH(NOLOCK)
	ON			B.TC_NumeroExpediente				= C.TC_NumeroExpediente
	And			C.TC_CodContexto					= @L_Contexto
	INNER JOIN	Catalogo.Clase						AS D WITH(NOLOCK)
	ON			C.TN_CodClase						= D.TN_CodClase
	INNER JOIN	Historico.AsignadosPaseFallo		AS E WITH(NOLOCK)
	ON			A.TU_CodPaseFallo					= E.TU_CodPaseFallo
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	AS F WITH(NOLOCK)
	ON			F.TC_CodPuestoTrabajo				= E.TC_CodPuestoTrabajo
	AND			F.TF_Inicio_Vigencia				<= GETDATE()
	AND			(F.TF_Fin_Vigencia					Is NULL
	OR			F.TF_Fin_Vigencia					> GETDATE())
	LEFT JOIN	Catalogo.Funcionario				AS G WITH(NOLOCK)
	ON			G.TC_UsuarioRed						= F.TC_UsuarioRed
	LEFT JOIN	Expediente.Resolucion				AS H WITH(NOLOCK)
	ON			H.TU_CodArchivo						= A.TU_CodArchivo
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	AS I WITH(NOLOCK)
	ON			I.TU_CodPuestoFuncionario			= H.TU_RedactorResponsable
	AND			I.TF_Inicio_Vigencia				<= GETDATE()
	AND			(I.TF_Fin_Vigencia					Is NULL
	OR			I.TF_Fin_Vigencia					> GETDATE())
	LEFT JOIN	Catalogo.Funcionario				AS J WITH(NOLOCK)
	ON			J.TC_UsuarioRed						= I.TC_UsuarioRed
	INNER JOIN  Catalogo.Proceso					AS K WITH(NOLOCK)
	ON			K.TN_CodProceso						= C.TN_CodProceso
	LEFT JOIN	Catalogo.MotivoDevolucionPaseFallo	AS M WITH(NOLOCK)
	ON			A.TN_CodMotivoDevolucion			= M.TN_CodMotivoDevolucion
	UNION ALL
	SELECT		A.TC_NumeroExpediente				AS NumeroExpediente,
				CONCAT(G.TC_Nombre, ' ', G.TC_PrimerApellido, ' ', G.TC_SegundoApellido) AS NombrePersonaAsignada,
				K.TC_Descripcion					AS ExpedienteAsunto,
				D.TN_CodClaseAsunto					AS Codigo,
				D.TC_Descripcion					AS Descripcion,
				A.TU_CodPaseFallo					AS CodigoPaseFallo,
				A.TF_FechaAsignacion				AS FechaAsignacion,
				A.TF_FechaVencimiento				AS FechaVencimiento,
				A.TF_FechaDevolucion				AS FechaDevolucion,
				B.TC_Descripcion					AS Descripcion,
				H.TF_FechaResolucion				AS FechaResolucion,
				CONCAT(J.TC_Nombre, ' ', J.TC_PrimerApellido, ' ', J.TC_SegundoApellido) AS NombrePersonaRedacta,
				A.TU_CodLegajo						AS CodigoLegajo,
				NULL,
				C.TN_CodProceso						AS CodigoProcesoLeg,
				L.TC_Descripcion					AS DescripcionProceso,
				(SELECT Expediente.FN_HorasPendientesFechaVence (@L_Contexto, A.TF_FechaVencimiento)) AS HorasPendientes,
				A.TN_CodMotivoDevolucion			AS CodMotivoDevolucion,
				M.TC_Descripcion					AS MotivoDevolucion
	FROM		Historico.PaseFallo					AS A WITH(NOLOCK)
	INNER JOIN	Expediente.Legajo					AS B WITH(NOLOCK)
	ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente
	AND			A.TF_FechaAsignacion				>= Coalesce(@L_FechaDesdePaseFallo, A.TF_FechaAsignacion)
	AND			A.TF_FechaAsignacion				<= Coalesce(@L_FechaHastaPaseFallo, A.TF_FechaAsignacion)
	AND			A.TF_FechaVencimiento				>= Coalesce(@L_FechaDesdeVencimiento, A.TF_FechaVencimiento)
	AND			A.TF_FechaVencimiento				<= Coalesce(@L_FechaHastaVencimiento, A.TF_FechaVencimiento)
	AND			A.TC_NumeroExpediente				= Coalesce(@L_NumeroExpediente, A.TC_NumeroExpediente)
	AND			A.TC_CodContexto					= Coalesce(@L_Contexto, A.TC_CodContexto)
	AND			A.TU_CodLegajo						= B.TU_CodLegajo
	INNER JOIN	Expediente.LegajoDetalle			AS C WITH(NOLOCK)
	ON			B.TU_CodLegajo						= C.TU_CodLegajo
	And			C.TC_CodContexto					= @L_Contexto
	INNER JOIN	Catalogo.ClaseAsunto				AS D WITH(NOLOCK)
	ON			C.TN_CodClaseAsunto					= D.TN_CodClaseAsunto
	INNER JOIN	Historico.AsignadosPaseFallo		AS E WITH(NOLOCK)
	ON			A.TU_CodPaseFallo					= E.TU_CodPaseFallo
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	AS F WITH(NOLOCK)
	ON			F.TC_CodPuestoTrabajo				= E.TC_CodPuestoTrabajo
	AND			F.TF_Inicio_Vigencia				<= GETDATE()
	AND			(F.TF_Fin_Vigencia					Is NULL
	OR			F.TF_Fin_Vigencia					> GETDATE())
	LEFT JOIN	Catalogo.Funcionario				AS G WITH(NOLOCK)
	ON			G.TC_UsuarioRed						= F.TC_UsuarioRed
	LEFT JOIN	Expediente.Resolucion				AS H WITH(NOLOCK)
	ON			H.TU_CodArchivo						= A.TU_CodArchivo
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	AS I WITH(NOLOCK)
	ON			I.TU_CodPuestoFuncionario			= H.TU_RedactorResponsable
	AND			I.TF_Inicio_Vigencia				<= GETDATE()
	AND			(I.TF_Fin_Vigencia					Is NULL
	OR			I.TF_Fin_Vigencia					> GETDATE())
	LEFT JOIN	Catalogo.Funcionario				AS J WITH(NOLOCK)
	ON			J.TC_UsuarioRed						= I.TC_UsuarioRed
	INNER JOIN	Catalogo.Asunto						AS K WITH(NOLOCK)
	ON			K.TN_CodAsunto						= C.TN_CodAsunto
	LEFT JOIN   Catalogo.Proceso					AS L WITH(NOLOCK)
	ON			L.TN_CodProceso						= C.TN_CodProceso
	LEFT JOIN	Catalogo.MotivoDevolucionPaseFallo	AS M WITH(NOLOCK)
	ON			A.TN_CodMotivoDevolucion			= M.TN_CodMotivoDevolucion

	IF (@L_FechaDesdeDevolucion IS NOT NULL AND @L_FechaHastaDevolucion IS NOT NULL)
	BEGIN
		DELETE
		FROM		@Result
		WHERE		FechaDevolucion						Is Null
		OR			FechaDevolucion						< Coalesce(@L_FechaDesdeDevolucion, FechaDevolucion)
		OR			FechaDevolucion						> Coalesce(@L_FechaHastaDevolucion, FechaDevolucion)
	END

	IF (@L_FechaDesdeResolucion IS NOT NULL AND @L_FechaHastaResolucion IS NOT NULL)
	BEGIN
		DELETE
		FROM		@Result
		WHERE		FechaResolucion						Is Null
		OR			FechaResolucion						< Coalesce(@L_FechaDesdeResolucion, FechaResolucion)
		OR			FechaResolucion						> Coalesce(@L_FechaHastaResolucion, FechaResolucion)
	END
	
	IF (@L_PersonaAsignada IS NOT NULL)
	BEGIN
		DELETE
		FROM		@Result
		WHERE		NombrePersonaAsignada				<> @L_PersonaAsignada
	END

	IF (@L_PersonaRedacta IS NOT NULL)
	BEGIN
		DELETE
		FROM		@Result
		WHERE		NombrePersonaRedacta				<> @L_PersonaRedacta
	END

	IF (@L_CargaInicial = 'True')
	BEGIN
		DELETE
		FROM		@Result
		WHERE		FechaDevolucion						Is Not Null
	END

	DECLARE @TotalRegistros AS INT = (SELECT COUNT(*) FROM @Result);  

	SELECT		NumeroExpediente					AS NumeroExpediente,
				NombrePersonaAsignada				AS NombrePersonaAsignada,
				MotivoDevolucion					AS MotivoDevolucion,
				ExpedienteAsunto					AS ExpedienteAsunto,
				@TotalRegistros						AS TotalRegistros,
				'Split'								AS SplitClase,
				CodigoClase							AS Codigo,
				DescripcionClase					AS Descripcion,
				'Split'								AS SplitPaseFallo,
				CodigoPaseFallo						AS Codigo,
				FechaAsignacion						AS FechaAsignacion,
				FechaVencimiento					AS FechaVencimiento,
				FechaDevolucion						AS FechaDevolucion,
				HorasPendientes						AS HorasPendientes,
				'Split'								AS SplitExpedienteDetalle,
				NumeroExpediente					AS Numero,
				DescripcionExpOLeg					AS Descripcion,
				'Split'								AS SplitLegajoDetalle,
				CodigoLegajo						AS Codigo,
				DescripcionExpOLeg					AS Descripcion,
				'Split'								As SplitMotivoDevolucion,
				CodMotivoDevolucion					As Codigo,
				MotivoDevolucion					As Descripcion,		
				'Split'								AS SplitOtros,
				CodigoProcesoExp,
				CodigoProcesoLeg,
				DescripcionProceso
	FROM		@Result
	ORDER BY CASE WHEN FechaDevolucion IS NULL THEN '9999-12-31 23:59:59.99' ELSE FechaDevolucion END DESC, FechaVencimiento asc
     OFFSET  (@NumeroPagina - 1) * @CantidadRegistros ROWS   
     FETCH NEXT @CantidadRegistros ROWS ONLY
END
GO
