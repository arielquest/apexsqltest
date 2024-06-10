SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==========================================================================================================================================================================  
-- Versión:				<1.2>  
-- Creado por:			<Jose Gabriel Cordero Soto>  
-- Fecha de creación:	<10/10/2019>  
-- Descripción :		<Consultar escrito asociado a un expediente>   
-- ==========================================================================================================================================================================  
-- Modificado por:	<16/10/2019><Jose Gabriel Cordero Soto><Se actualizan datos en la consulta que carga el listado>  
-- Modificado por:	<18/10/2019><Jose Gabriel Cordero Soto><Agregar campo fecha registro CEREDOC en resultado de consulta>  
-- Modificado por:	<24/10/2019><Jose Gabriel Cordero Soto><Agregar campo fecha registro CEREDOC en resultado de consulta>  
-- Modificado por:	<10/12/2019><Jose Gabriel Cordero Soto><Agregar campo codigo archivo en resultado de consulta>  
-- Modificado por:	<12/12/2019><Jose Gabriel Cordero Soto><Se ajusta nombramiento de variables locales por observación en revisión par>  
-- Modificado por:	<26/05/2020><Xinia Soto V><Se agrega al select el indicador de si el escrito posee de varias gestiones>  
--- ==========================================================================================================================================================================  
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<27/05/2020>
-- Modificación				<Se aplica formato general al SP>
-- Modificado por:	<22-08-2022><Aaron Rios Retana><HU 270202 - Se coloca un left join en relacion con el puesto de trabajo ya que el mismo puede ser nulo
--													,a su vez se permite que sea nulo el parametro en el where>
-- Modificación				<14/07/2023><Ronny Ramírez R.>  <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE/ISNULL en el WHERE>
-- ===========================================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ConsultarEscritoAsociadoAExpediente]  
	@Codigo					UNIQUEIDENTIFIER	= NULL,  
	@CodPuestoTrabajo		VARCHAR(14)			= NULL,  
	@NumeroExpediente		CHAR(14)			= NULL,  
	@CodTipoEscrito			SMALLINT			= NULL,  
	@CodContexto			VARCHAR(4)			= NULL,  
	@Descripcion			VARCHAR(255)		= NULL,  
	@FechaIngresoOficina	DATETIME2(2)		= NULL,    
	@FechaEnvio				DATETIME2(2)		= NULL,  
	@CantidadPagina			SMALLINT			= Null,  
	@IndicePagina			SMALLINT			= Null,  
	@EstadoEscrito          CHAR(1)             = Null   
AS  
Begin   
	--Varibles Locales para utilización de parametros de entrada  
	DECLARE @L_Codigo				UNIQUEIDENTIFIER	= @Codigo  
	DECLARE @L_CodPuestoTrabajo		VARCHAR(14)			= @CodPuestoTrabajo  
	DECLARE @L_NumeroExpediente		CHAR(14)			= @NumeroExpediente  
	DECLARE @L_CodTipoEscrito		SMALLINT			= @CodTipoEscrito  
	DECLARE @L_CodContexto			VARCHAR(4)			= @CodContexto  
	DECLARE @L_Descripcion			VARCHAR(255)		= @Descripcion  
	DECLARE @L_FechaIngresoOficina  DATETIME2(2)		= @FechaIngresoOficina    
	DECLARE @L_FechaEnvio			DATETIME2(2)		= @FechaEnvio  
	DECLARE @L_CantidadPagina		SMALLINT			= @CantidadPagina  
	DECLARE @L_IndicePagina			SMALLINT			= @IndicePagina  
	DECLARE @L_EstadoEscrito		CHAR(1)             = @EstadoEscrito   
  
	--Variables Locales para obtener información sobre Movimiento en el circulante  
	DECLARE  @L_CodigoEstado			int  
	DECLARE  @L_EstadoExpediente		varchar(255)  
	DECLARE  @L_FechaEstadoExpediente   datetime2(3)  
  
	If (@L_IndicePagina Is Null Or @L_CantidadPagina Is Null)  
	Begin  
		SET @L_IndicePagina = 0;  
		SET @L_CantidadPagina = 32767;  
	End  
    
	SELECT		Top(1) 
				@L_EstadoExpediente							= B.TC_Descripcion    
				,@L_FechaEstadoExpediente					= A.TF_Fecha  
				,@L_CodigoEstado							= B.TN_CodEstado  
	
	FROM		Historico.ExpedienteMovimientoCirculante	A WITH(Nolock) 
	INNER JOIN	Catalogo.Estado								B WITH(Nolock)
	ON			A.TN_CodEstado								= B.TN_CodEstado  
	WHERE		TC_NumeroExpediente							= @L_NumeroExpediente 
	ORDER BY	TF_Fecha									DESC  
  
	SELECT	A.TU_CodEscrito					AS		Codigo  
			,A.TC_Descripcion				AS		Descripcion  
			,A.TF_FechaIngresoOficina		AS		FechaIngresoOficina  
			,A.TF_FechaEnvio				AS		FechaEnvio    
			,A.TC_CodEntrega				AS		CodigoEntrega  
			,A.TC_EstadoEscrito				AS		EstadoEscrito  
			,A.TC_Descripcion				AS		Descripcion  
			,A.TF_FechaRegistro				AS		FechaRegistro  
			,A.TC_IDARCHIVO					AS		CodigoArchivo
			,A.TB_VariasGestiones			AS		VariasGestiones
			,'splitExpedienteCirculante'	AS		splitExpedienteCirculante  
			,@L_FechaEstadoExpediente		AS		Fecha   
			,'splitEstadoExpediente'		AS		splitEstadoExpediente  
			,@L_CodigoEstado				AS		Codigo    
			,@L_EstadoExpediente			AS		Descripcion      
			,'splitContexto'				AS		SplitContexto   
			,B.TC_CodContexto				AS		Codigo  
			,B.TC_Descripcion				AS		Descripcion  
			,'splitPuestoTrabajo'			AS		SplitPuestoTrabajo  
			,C.TC_CodPuestoTrabajo			AS		Codigo  
			,C.TC_Descripcion				AS		Descripcion  
			,'splitExpediente'				AS		SplitExpediente  
			,D.TC_NumeroExpediente			AS		Numero  
			,D.TC_Descripcion				AS		Descripcion  
			,'splitTipoEscrito'				AS		SplitTipoEscrito  
			,A.TN_CodTipoEscrito			AS		Codigo  
			,E.TC_Descripcion				AS		Descripcion
      
	FROM	Expediente.EscritoExpediente	A With(Nolock)  
  
		INNER JOIN   
		(  
			SELECT	EE.TU_CodEscrito  
			FROM	Expediente.EscritoExpediente		EE	With(Nolock)  
			WHERE	EE.TC_NumeroExpediente				= ISNULL(@L_NumeroExpediente, EE.TC_NumeroExpediente)  
			
			EXCEPT  
			
			SELECT  EL.TU_CodEscrito  
			FROM	Expediente.EscritoLegajo			EL  With(Nolock)  
			JOIN	Expediente.Legajo					L	With(Nolock) 
			ON		EL.TU_CodLegajo = L.TU_CodLegajo  
			WHERE	L.TC_NumeroExpediente				= ISNULL(@L_NumeroExpediente, L.TC_NumeroExpediente)  

		)											AS X  
		ON   X.TU_CodEscrito						= A.TU_CodEscrito   
  
		INNER JOIN Catalogo.Contexto				B WITH(Nolock)  
		ON   A.TC_CodContexto						= B.TC_CodContexto  
  
		LEFT JOIN Catalogo.PuestoTrabajo			C WITH(Nolock)  
		ON   A.TC_CodPuestoTrabajo					= C.TC_CodPuestoTrabajo  
  
		INNER JOIN Expediente.Expediente			D WITH(Nolock)  
		ON   A.TC_NumeroExpediente					= D.TC_NumeroExpediente  
  
		INNER JOIN Catalogo.TipoEscrito				E WITH(Nolock)  
		ON   A.TN_CodTipoEscrito					= E.TN_CodTipoEscrito  

	WHERE	A.TU_CodEscrito					=  ISNULL(@L_Codigo, A.TU_CodEscrito)  
	AND	(
			A.TC_Descripcion				LIKE '%' + ISNULL(@L_Descripcion ,A.TC_Descripcion) + '%' 
			OR @L_Descripcion				IS NULL
		)  
	AND	(
			A.TC_CodPuestoTrabajo			=  ISNULL(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)  
			OR @L_CodPuestoTrabajo			IS NULL
		)
	AND		A.TC_NumeroExpediente			=  ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)  
	AND		A.TN_CodTipoEscrito				=  ISNULL(@L_CodTipoEscrito, A.TN_CodTipoEscrito)  
	AND		A.TC_EstadoEscrito				=  ISNULL(@L_EstadoEscrito, A.TC_EstadoEscrito)   
  
	ORDER BY	A.TF_FechaEnvio							Asc  
	Offset		@L_IndicePagina * @L_CantidadPagina		Rows  
	Fetch Next	@L_CantidadPagina						Rows Only
	OPTION(RECOMPILE);
  
End  
GO
