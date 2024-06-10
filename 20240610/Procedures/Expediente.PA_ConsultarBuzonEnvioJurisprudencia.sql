SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<08/08/2018>
-- Descripción :			<Permite Consultar las resoluciones que se envian a jurisprudencia>
-- Modificación:			<Isaac Dobles Mata> <26/09/2018> <Se modifica para tomar en cuenta consulta a tablas Archivo y ArchivoExpediente>  
-- Modificación:			<Jonathan Aguilar Navarro> <20/05/2019> <Se modifica la consulta para que devuelva el codigoArchivo que se almacena para descargar documento>
-- Modificación:			<Adrián Arias Abarca> <18/11/2019> <Se modifica la consulta para que tome en cuenta el contexto desde donde se ejecuta la consulta.>
-- =================================================================================================================================================
 --   exec [Expediente].[PA_ConsultarBuzonEnvioJurisprudencia]   1,50,'P','F',null,null,null,null,null,null,null,null,null,null 
CREATE Procedure [Expediente].[PA_ConsultarBuzonEnvioJurisprudencia]   
 	@NumeroPagina				Int,
	@CantidadRegistros			Int,
	@EstadoEnvio	    		Char(1),
	@EstadoFirmado              Char(1),	
	@NumeroSentencia			Int					= NULL,
	@FechaSentencia				Date				= NULL,
	@CodigoResultado			Smallint			= NULL, 
	@CodigoRedactor				UniqueIdentifier	= NULL,  
	@CodigoEnviadoPor			Varchar(50)			= NULL,
	@Confidencial				Bit					= NULL,
	@Relevante					Bit					= NULL,
	@FechaDesde					Datetime2			= NULL,
	@FechaHasta					Datetime2			= NULL,
	@NumeroExpediente			Varchar(14)			= NULL,
	@Contexto					Varchar(4)
As
Begin
 
Declare @Sentencias As Table
  (
		CodigoSentencia					UniqueIdentifier,
		CodigoArchivo					UniqueIdentifier,	
		EstadoEnvio						Char(1),
		NumeroExpediente				Varchar(14), 
		FechaSentencia					Datetime2(7),
		NumeroSentencia					Varchar(20),
		CodigoResultadoSentencia		Smallint,
		DescripcionResultadoSentencia	Varchar(100),
		CodigoRedactor					UniqueIdentifier,
		DescripcionRedactor				Varchar(100),  
		FechaEnvio						Datetime2(7),
		CodigoEnviadoPor				Varchar(30),
		DescripcionEnviadoPor			Varchar(100),
		Relevante						Bit,
		Confidencial					Bit,
		Observaciones					Varchar(255) ,
		TotalRegistros					Int
  )

Declare @1NumeroPagina				Int					= @NumeroPagina,
		@1CantidadRegistros			Int					= @CantidadRegistros,
		@1EstadoEnvio	    		Char(1)				= @EstadoEnvio,
		@1EstadoFirmado             Char(1)				= @EstadoFirmado,
		@1NumeroSentencia			Int					= @NumeroSentencia,
		@1FechaSentencia			Date				= @FechaSentencia,
		@1CodigoResultado			Smallint			= @CodigoResultado, 
		@1CodigoRedactor			UniqueIdentifier	= @CodigoRedactor,  
		@1CodigoEnviadoPor			Varchar(50)			= @CodigoEnviadoPor,
		@1Confidencial				Bit					= @Confidencial,
		@1Relevante					Bit					= @Relevante,
		@1FechaDesde				Datetime2			= @FechaDesde,
		@1FechaHasta				Datetime2			= @FechaHasta,
		@1NumeroExpediente			Varchar(14)			= @NumeroExpediente,
		@1Contexto					Varchar(4) 			= @Contexto


  If( @1NumeroPagina is null) Set @1NumeroPagina=1;

	Insert Into @Sentencias
	(
		CodigoSentencia,		CodigoArchivo,			CodigoResultadoSentencia,		CodigoRedactor, 
		DescripcionRedactor,	CodigoEnviadoPor,		NumeroSentencia,				NumeroExpediente,
		Confidencial,			FechaSentencia,			FechaEnvio,						Relevante,
		Observaciones,			EstadoEnvio 
	)	
	Select 
		R.TU_CodResolucion,		AE.TU_CodArchivo,		R.TN_CodResultadoResolucion,	R.TU_RedactorResponsable, 	
		RTRIM(F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + Coalesce(F.TC_SegundoApellido,'')),
		R.TC_UsuarioRedSAS,
		replicate('0' , 6- LEN( CAST(LS.TC_NumeroResolucion AS Varchar)))+CAST(LS.TC_NumeroResolucion As Varchar),
		AE.TC_NumeroExpediente,	E.TB_Confidencial,		R.TF_FechaResolucion,			R.TF_FechaEnvioSAS,
		R.TB_Relevante,			R.TC_ObservacionSAS,	R.TC_EstadoEnvioSAS 
	From 
		Expediente.Resolucion							R With(NoLock)
	    INNER JOIN Archivo.Archivo						AR With(NoLock)
		on R.TU_CodArchivo								= AR.TU_CodArchivo
		INNER JOIN Expediente.ArchivoExpediente			AE With(NoLock)
		on R.TU_CodArchivo								= AE.TU_CodArchivo	
		INNER JOIN Archivo.AsignacionFirmado			FF With(NoLock)
		on AE.TU_CodArchivo								=FF.TU_CodArchivo
		INNER JOIN Expediente.LibroSentencia			LS With(NoLock)  --Sentencia con voto 
		on R.TU_CodResolucion							= LS.TU_CodResolucion
        INNER JOIN Expediente.Expediente				E With(NoLock) 
		on E.TC_NumeroExpediente						= AE.TC_NumeroExpediente
        inner join Catalogo.PuestoTrabajoFuncionario	PTF With(NoLock) 
		on R.TU_RedactorResponsable						= PTF.TU_CodPuestoFuncionario  
		INNER JOIN Catalogo .Funcionario				F With(NoLock) 
		ON PTF.TC_UsuarioRed							= F.TC_UsuarioRed 		  
 	Where 
		R.TC_EstadoEnvioSAS								= COALESCE(@1EstadoEnvio, R.TC_EstadoEnvioSAS) 
		And E.TC_CodContexto							= @1Contexto
	    AND FF.TC_Estado								= @1EstadoFirmado --Documento Firmado
		AND R.TF_FechaResolucion						IS NOT NULL --Sentencia con fecha
		AND R.TN_CodResultadoResolucion					= COALESCE	(@1CodigoResultado,	R.TN_CodResultadoResolucion)
		AND E.TB_Confidencial							= COALESCE	(@1Confidencial,	E.TB_Confidencial) 
	    AND R.TB_Relevante								= COALESCE	(@1Relevante,		R.TB_Relevante) 
		AND LS.TC_NumeroResolucion						= CASE WHEN @1NumeroSentencia	IS NULL THEN LS.TC_NumeroResolucion		ELSE @1NumeroSentencia	END	
	    AND AE.TC_NumeroExpediente						= CASE WHEN @1NumeroExpediente	IS NULL THEN AE.TC_NumeroExpediente		ELSE @1NumeroExpediente END  
		AND R.TU_RedactorResponsable					= CASE WHEN @1CodigoRedactor	IS NULL THEN R.TU_RedactorResponsable	ELSE @1CodigoRedactor	END		
		AND (@1CodigoEnviadoPor							IS NULL OR	R.TC_UsuarioRedSAS	= R.TC_UsuarioRedSAS)  	
		AND (@1FechaSentencia	 						IS NULL OR	convert(date,	R.TF_FechaResolucion,	3) = @1FechaSentencia) 
		AND (@1FechaDesde								IS NULL OR	R.TF_FechaEnvioSAS	>= @1FechaDesde)
		AND (@1FechaHasta								IS NULL OR	R.TF_FechaEnvioSAS	<= @1FechaHasta)  
    Order By R.TF_FechaResolucion
	
	Declare @TotalRegistros AS INT = @@rowcount;  
  
	Select	
		X.CodigoSentencia,		X.CodigoArchivo,					X.NumeroExpediente,									X.FechaSentencia,
		X.NumeroSentencia,		X.CodigoResultadoSentencia,			RR.TC_Descripcion DescripcionResultadoSentencia,	X.CodigoRedactor,	
		X.DescripcionRedactor,	X.FechaEnvio,						X.CodigoEnviadoPor,									RTRIM(F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + Coalesce(F.TC_SegundoApellido,'')) DescripcionEnviadoPor,
		X.Relevante,			X.Confidencial,
		X.Observaciones,		@TotalRegistros	 As TotalRegistros,	'split' As split,									X.EstadoEnvio,
		X.CodigoArchivo
	From  
		(Select
			CodigoSentencia,		CodigoArchivo,		CodigoResultadoSentencia,	CodigoRedactor,
			DescripcionRedactor,	CodigoEnviadoPor,	NumeroSentencia,			NumeroExpediente,
			Confidencial,			FechaSentencia,		FechaEnvio,					Relevante,
			Observaciones,			EstadoEnvio
		From		
			@Sentencias
		Order By	
			EstadoEnvio Desc,		FechaEnvio Asc
		OFFSET
			(@1NumeroPagina - 1) * @1CantidadRegistros Rows 
		Fetch Next
			@1CantidadRegistros Rows ONLY
		) As X  
		Inner Join Catalogo.ResultadoResolucion	RR With(NoLock) 
		On X.CodigoResultadoSentencia			= RR.TN_CodResultadoResolucion 
		Left Join Catalogo.Funcionario          F With(NoLock)
		On  X.CodigoEnviadoPor                  = F.TC_UsuarioRed
		Order By
			EstadoEnvio Desc,		FechaEnvio Asc,		FechaSentencia Asc
 
end
GO
