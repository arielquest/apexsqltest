SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Méndez Cha>
-- Fecha de creación:		<21/08/2018>
-- Descripción :			<Permite Consultar los Apremios de un expediente para el buzon de Apremios>
-- =================================================================================================================================================
-- Modificación :			<11/02/2021><Daniel Ruiz Hernández><Se cambia el tipo de dato para CodigoAsunto de smallint a int>
-- Modificación :			<27/10/2021><Wagner Vargas Sanabria><se agrega tiempo transcurrido y lista de responsables>
-- Modificación :			<11/01/2022><Jose Gabriel Cordero Soto><Se realiza ajuste en calculo del tiempo transcurrido, dado que solo cuanto esta en estado tramitandose se debe considerar el conteo>
-- Modificación :			<02/02/2022><Jose Gabriel Cordero Soto><Se realiza ajuste en calculo del tiempo transcurrido, dado que no se esta calculando de forma correcta los dias>
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarBuzonApremios]   
 	@NumeroPagina				int,
	@CantidadRegistros			int,	
	@FechaDesde					datetime2	=	NULL,
	@FechaHasta					datetime2	=	NULL,
	@FechaDesdeCambioEstado		datetime2	=	NULL,
	@FechaHastaCambioEstado		datetime2	=	NULL,
	@NumeroExpediente			varchar(14)	=	NULL,
	@EstadoApremio				char(1)		=	NULL,	
	@OrigenApremio				char(1)		=	NULL,	
	@CodContexto				varchar(4)	=	NULL,
	@CodPuestoTrabajo			varchar(14)	=	NULL
	
AS
BEGIN
	--Variables
	Declare	@L_NumeroPagina				int			=	@NumeroPagina		,
			@L_CantidadRegistros		int			=	@CantidadRegistros	,	
			@L_FechaDesde				datetime2	=	@FechaDesde			,
			@L_FechaHasta				datetime2	=	@FechaHasta			,
			@L_FechaDesdeCambioEstado	datetime2	=	@FechaDesdeCambioEstado,
			@L_FechaHastaCambioEstado	datetime2	=	@FechaHastaCambioEstado,
			@L_NumeroExpediente			varchar(14)	=	@NumeroExpediente	,
			@L_EstadoApremio			char(1)		=	@EstadoApremio		,	
			@L_OrigenApremio			char(1)		=	@OrigenApremio		,	
			@L_CodContexto				varchar(4)	=	@CodContexto		,
			@L_CodPuestoTrabajo			varchar(14)	=	@CodPuestoTrabajo

	DECLARE @Apremios AS TABLE
	(
		Codigo							uniqueidentifier,
		Descripcion						varchar(255),
		FechaIngresoOficina				datetime2(2),
		FechaEnvio						datetime2(2),
		FechaEstado						datetime2(2),
		TiempoTranscurrido				int,
		EstadoApremio					varchar(1),
		OrigenApremio					varchar(1),
		CodigoLegajo					uniqueidentifier,
		NumeroExpediente				char(14),
		CodigoAsunto					int,
		DescripcionAsunto				varchar(100),
		CodigoArchivo					uniqueidentifier,
		CodigoPuestoTrabajo				varchar(14),
		DescripcionPuestoTrabajo		varchar(75),
		NombreFuncionario				varchar(50),
		PrimerApellidoFuncionario		varchar(50),
		SegundoApellidoFuncionario		varchar(50),
		Responsables					varchar(8000)
	)

	IF( @L_NumeroPagina is null) SET @L_NumeroPagina=1;
	
	INSERT INTO @Apremios
	(
		Codigo,					
		Descripcion,				
		FechaIngresoOficina,		
		FechaEnvio,
		FechaEstado,
		TiempoTranscurrido,
		EstadoApremio,		
		OrigenApremio,
		CodigoLegajo,
		NumeroExpediente,
		CodigoAsunto,	
		DescripcionAsunto,		
		CodigoArchivo, 
		CodigoPuestoTrabajo,
		DescripcionPuestoTrabajo,
		NombreFuncionario,
		PrimerApellidoFuncionario,
		SegundoApellidoFuncionario, 
		Responsables
	) 
	SELECT	 A.TU_CodApremio								AS		Codigo
			,A.TC_Descripcion								AS		Descripcion
			,A.TF_FechaIngresoOficina						AS		FechaIngresoOficina
			,A.TF_FechaEnvio								AS		FechaEnvio
			,A.TF_FechaEstado								AS		FechaEstado
			,0												AS	 	TiempoTranscurrido			
			,A.TC_EstadoApremio								AS		EstadoApremio
			,A.TC_OrigenApremio								AS		OrigenApremio
			,L.TU_CodLegajo									As		CodigoLegajo
			,L.TC_NumeroExpediente							AS		NumeroExpediente
			,C.TN_CodClaseAsunto							AS		CodigoAsunto
			,C.TC_Descripcion								AS		DescripcionAsunto
			,A.TC_IDARCHIVO									AS		CodigoArchivo
			,PT.TC_CodPuestoTrabajo							AS		CodigoPuestoTrabajo
			,PT.TC_Descripcion								AS		DescripcionPuestoTrabajo
			,F.TC_Nombre									AS		NombreFuncionario
			,F.TC_PrimerApellido							AS		PrimerApellidoFuncionario
			,F.TC_SegundoApellido							AS		SegundoApellidoFuncionario
			, (select stuff(
   (SELECT ', '+PT.TC_Descripcion+'-'+F.TC_Nombre +' '+F.TC_PrimerApellido+' '+F.TC_SegundoApellido 
	FROM [Historico].[LegajoAsignado] LA
	
  	Left JOIN	Catalogo.PuestoTrabajo				PT	WITH(Nolock)
	ON		LA.TC_CodPuestoTrabajo				=	PT.TC_CodPuestoTrabajo	
	Left Join	Catalogo.PuestoTrabajoFuncionario	PF	WITH(Nolock)
	ON		LA.TC_CodPuestoTrabajo				=	PF.TC_CodPuestoTrabajo
	AND		(PF.TF_Fin_Vigencia					Is	NULL	OR	PF.TF_Fin_Vigencia	>=	Getdate())
	Left Join	Catalogo.Funcionario				F	WITH(Nolock)
	ON		PF.TC_UsuarioRed					=	F.TC_UsuarioRed
	
	WHERE (LA.TF_Fin_Vigencia is null or LA.TF_Fin_Vigencia >=	Getdate()) and LA.TB_EsResponsable =1 and LA.TU_CodLegajo= A.TU_CodLegajo
	for xml path('')),1,2, '') as 'Responsables')
	
	FROM		Expediente.ApremioLegajo			A	WITH(NOLOCK)
	JOIN		Expediente.Legajo					L	WITH(NOLOCK)
	ON			A.TU_CodLegajo						=	L.TU_CodLegajo
	JOIN		Expediente.LegajoDetalle			LD	WITH(NOLOCK)
	ON			A.TU_CodLegajo						=	LD.TU_CodLegajo
	JOIN		Catalogo.ClaseAsunto				C	WITH(NOLOCK)
	ON			LD.TN_CodClaseAsunto				=	C.TN_CodClaseAsunto
	JOIN		Catalogo.Contexto					B	WITH(NOLOCK)	
	ON			A.TC_CodContexto					=	B.TC_CodContexto		
	Left JOIN	Catalogo.PuestoTrabajo				PT	WITH(Nolock)
	ON			A.TC_CodPuestoTrabajo				=	PT.TC_CodPuestoTrabajo	
	Left Join	Catalogo.PuestoTrabajoFuncionario	PF	WITH(Nolock)
	ON			A.TC_CodPuestoTrabajo				=	PF.TC_CodPuestoTrabajo
	AND		   (PF.TF_Fin_Vigencia					Is	NULL	OR	PF.TF_Fin_Vigencia	>=	Getdate())
	Left Join	Catalogo.Funcionario				F	WITH(Nolock)
	ON			PF.TC_UsuarioRed					=	F.TC_UsuarioRed

	WHERE		L.TC_NumeroExpediente				=	ISNULL(@L_NumeroExpediente, L.TC_NumeroExpediente)		
	AND			A.TC_EstadoApremio					=	ISNULL(@L_EstadoApremio, A.TC_EstadoApremio)
	AND			A.TC_OrigenApremio					=	ISNULL(@L_OrigenApremio, A.TC_OrigenApremio)
	AND			B.TC_CodContexto					=	ISNULL(@L_CodContexto, B.TC_CodContexto)	
	AND		   (@L_CodPuestoTrabajo					IS NULL 
	OR			PT.TC_CodPuestoTrabajo				=	ISNULL(@L_CodPuestoTrabajo, PT.TC_CodPuestoTrabajo))
	AND		   (@L_FechaHasta						IS NULL 
	OR			DATEDIFF(day, A.TF_fechaIngresoOficina,@L_FechaHasta) >= 0)
	AND		   (@L_FechaDesde						IS NULL 
	OR			DATEDIFF(day, A.TF_fechaIngresoOficina,@L_FechaDesde) <= 0)	
	AND		   (@L_FechaHastaCambioEstado			IS NULL 
	OR			DATEDIFF(day, A.TF_FechaEstado,@L_FechaHastaCambioEstado) >= 0)
	AND		   (@L_FechaDesdeCambioEstado			IS NULL 
	OR			DATEDIFF(day, A.TF_FechaEstado,@L_FechaDesdeCambioEstado) <= 0)	

	ORDER BY	A.TF_FechaEnvio		ASC

	--Obtener cantidad registros de la consulta
	DECLARE @TotalRegistros AS INT = @@rowcount; 

	update @Apremios 
	--set TiempoTranscurrido = ((datediff(day,GETDATE(),FechaEstado))-1) WHERE EstadoApremio IN ('T') 
	set TiempoTranscurrido = ((datediff(day,FechaEstado,GETDATE()))) WHERE EstadoApremio IN ('T')


	--SI EL TIEMPO TRANSCURRIDO ES MENOR A 0
	UPDATE  @Apremios SET TiempoTranscurrido = 0 WHERE TiempoTranscurrido < 0

	--retornar consultar
	SELECT T.Codigo					
			,T.Descripcion				
			,T.FechaIngresoOficina		
			,T.FechaEnvio
			,T.TiempoTranscurrido
			,@TotalRegistros				AS		TotalRegistros		
			,T.EstadoApremio	
			,T.OrigenApremio
			,T.Responsables				AS		Responsables
			,'Split'						AS		Split
			,T.CodigoLegajo				AS		Codigo
			,'Split'						AS		Split
			,T.NumeroExpediente			As		Numero
			,'Split'						AS		Split
			,T.CodigoAsunto				AS		Codigo
			,T.DescripcionAsunto			AS		Descripcion	
			,'Split'						AS		Split			 
			,T.CodigoArchivo				AS		Codigo
			,'Split'						AS		Split	
			,T.CodigoPuestoTrabajo		AS		Codigo
			,T.DescripcionPuestoTrabajo	AS		Descripcion
			,'Split'						AS		Split	
			,T.NombreFuncionario			AS		Nombre
			,T.PrimerApellidoFuncionario	AS		PrimerApellido
			,T.SegundoApellidoFuncionario	AS		SegundoApellido
			  
	FROM (
			SELECT		Codigo					
						,Descripcion			
						,FechaIngresoOficina	
						,FechaEnvio
						,TiempoTranscurrido
						,EstadoApremio
						,OrigenApremio
						,Responsables
						,CodigoLegajo
						,NumeroExpediente
						,CodigoAsunto
						,DescripcionAsunto
						,CodigoArchivo	
						,CodigoPuestoTrabajo		
						,DescripcionPuestoTrabajo	
						,NombreFuncionario				
						,PrimerApellidoFuncionario			
						,SegundoApellidoFuncionario
							
			FROM		@Apremios
			ORDER BY	FechaEnvio	Asc
			OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
			FETCH NEXT	@L_CantidadRegistros ROWS ONLY
		)	As T
	ORDER BY	T.FechaEnvio		Asc 
END
GO
