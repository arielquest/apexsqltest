SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Consulta].[PA_PST_ExpedienteDepurado4]
	@WHERE WHERECONSULTA READONLY,
	@CantidaRegistros int = 50,
	@NumeroPagina int= 1
AS
BEGIN
select 'inicio temporales '+(CONVERT( VARCHAR(24), GETDATE(), 121))
--CREATE TYPE WHERECONSULTA AS TABLE (
-- NombreCampo Varchar(100) NOT NULL PRIMARY KEY,
-- ValorCampo Varchar(255) NULL
--)
   	DECLARE @TN_Total				BIGINT			      = 0,
			@L_Where			   [WHERECONSULTA],
			@L_CantidadRegistros	INT					  = @CantidaRegistros,
			@L_NumeroPagina			INT					  = @NumeroPagina,
			@L_contexto		   	varchar(4)			    =     @NumeroPagina
   
   INSERT INTO @L_Where select * from @WHERE
   set @L_contexto = (SELECT Valorcampo FROM @L_Where WHERE NombreCampo='Contexto')

	DECLARE @DatosFinal TABLE(
		Expediente		CHAR(14)			NOT NULL,
		CodigoAsunto	INT					NULL,
		Asunto			VARCHAR(200)		NULL,
		CodigoFase		INT					NULL,
		Fase			VARCHAR(255)		NULL,
		Contexto		VARCHAR(4)			NOT NULL,
		FechaEntrada	DATETIME2(7)		NOT NULL,
		Legajo			UNIQUEIDENTIFIER	NULL,
		Descripcion		VARCHAR(255)        NULL,
		TotalRegistros  BIGINT				NOT NULL
    )
	Declare @Datos TABLE(
		Expediente		CHAR(14)			NOT NULL,
		CodigoAsunto	INT					NULL ,
		Asunto			VARCHAR(200)		NULL,
		CodigoFase		INT					NULL ,
		Fase			VARCHAR(255)		NULL,
		Contexto		VARCHAR(4)			NOT NULL,
		FechaEntrada	DATETIME2(7)		NOT NULL,
		Legajo			UNIQUEIDENTIFIER	NULL,
		Descripcion		VARCHAR(255)        NULL,
		TotalRegistros  BIGINT				NULL DEFAULT 0
  )
  	Declare @DatosFase TABLE(
		Expediente		CHAR(14)			NOT NULL,
		CodigoFase		INT					NULL ,
		FechaFase       DATETIME2(7)  NOT NULL 
		)
   	Declare @Expedientes TABLE(
		Expediente		CHAR(14)			NOT NULL,
		Contexto		CHAR(4)			NULL

    )
	
	Declare @Legajos TABLE(
		Legajo		UNIQUEIDENTIFIER		NOT	NULL  ,
		Contexto		CHAR(4)			NULL 
    )
	select 'fin temporales '+(CONVERT( VARCHAR(24), GETDATE(), 121))

	select 'inicio entrada'+(CONVERT( VARCHAR(24), GETDATE(), 121))
	 INSERT INTO @Expedientes
	 (
	  Expediente,Contexto
	 )
	 SELECT TC_NumeroExpediente,EES.TC_CodContexto
	 FROM Historico.ExpedienteEntradaSalida EES WITH(NOLOCK)
	 WHERE EES.TC_CodContexto= @L_contexto
    select 'fin entrada'+(CONVERT( VARCHAR(24), GETDATE(), 121))

	select 'inicio fase'+(CONVERT( VARCHAR(24), GETDATE(), 121))
	 INSERT INTO @DatosFase
	 (
	  Expediente,CodigoFase,FechaFase
	 )
	 SELECT TC_NumeroExpediente,EES.TN_CodFase,EES.TF_Fase
	 FROM Historico.ExpedienteFase EES WITH(NOLOCK)
	 WHERE EES.TC_CodContexto= @L_contexto
    select 'fin fase'+(CONVERT( VARCHAR(24), GETDATE(), 121))

	--INSERT INTO @Legajos
	 --(
	 -- Legajo,Contexto
	 --)
	 --SELECT LES.TU_CodLegajo, LES.TC_CodContexto
	 --FROM Historico.LegajoEntradaSalida LES
	 --INNER JOIN Expediente.Legajo L
	 --ON L.TU_CodLegajo= LES.TU_CodLegajo
	 --WHERE LES.TC_CodContexto= ISNULL((SELECT Valorcampo FROM @L_Where WHERE NombreCampo='Contexto'),LES.TC_CodContexto)
	 select 'inicio detalle'+(CONVERT( VARCHAR(24), GETDATE(), 121))
	INSERT INTO	@Datos
	(
				Expediente,						Contexto,			FechaEntrada, Descripcion
	)
	SELECT		E.TC_NumeroExpediente,			E.TC_CodContexto,	ED.TF_Entrada, E.TC_Descripcion		
	FROM		Expediente.Expediente			E WITH(NOLOCK)
    INNER JOIN	Expediente.ExpedienteDetalle	ED WITH(NOLOCK) 
	ON			E.TC_NumeroExpediente			= ED.TC_NumeroExpediente 
	INNER JOIN  @Expedientes EE
	on EE.Expediente= e.TC_NumeroExpediente and EE.Contexto= ED.TC_CodContexto
	select 'fin detalle'+(CONVERT( VARCHAR(24), GETDATE(), 121))
	
	--
	INSERT INTO	@Datos
	(
				Expediente,					CodigoAsunto,		Contexto,			FechaEntrada,
				Legajo,						Descripcion
	)
	SELECT		L.TC_NumeroExpediente,		LD.TN_CodAsunto,	L.TC_CodContexto,			LD.TF_Entrada,
				L.TU_CodLegajo,				L.TC_Descripcion
	FROM	    Expediente.Legajo			L WITH(NOLOCK)
	INNER JOIN	Expediente.LegajoDetalle	LD WITH(NOLOCK)
	ON			L.TU_CodLegajo				= LD.TU_CodLegajo
    INNER JOIN @Legajos LL
	ON LL.Legajo = L.TU_CodLegajo
	
	--CROSS APPLY funciona mejor en este caso que outer apply
	select 'inicio fase 2 '+(CONVERT( VARCHAR(24), GETDATE(), 121))
	UPDATE		A
	SET			A.CodigoFase	= B.CodigoFase
	FROM		@Datos	A
	 CROSS APPLY	(
					SELECT TOP 1	EF.CodigoFase
					FROM            @DatosFase EF 
					WHERE			EF.Expediente		= A.Expediente
					--AND				EF.Contexto			= A.Contexto
					ORDER BY		EF.FechaFase		DESC
				) B
select 'fin fase 2 '+(CONVERT( VARCHAR(24), GETDATE(), 121))
	--UPDATE		A
	--SET			A.CodigoFase	= B.TN_CodFase
	--FROM		@Datos	A
	-- CROSS APPLY	(
	--				SELECT TOP 1	EF.TN_CodFase
	--				FROM            Historico.ExpedienteFase EF 
	--				WHERE			EF.TC_NumeroExpediente		= A.Expediente
	--				AND				EF.TC_CodContexto			= A.Contexto
	--				ORDER BY		EF.TF_Fase		DESC
	--			) B

	--UPDATE		A
	--SET			A.CodigoFase	= B.TN_CodFase
	--FROM		@Datos	A
	--CROSS APPLY	(
	--				SELECT TOP 1	LF.TN_CodFase
	--				FROM			Historico.LegajoFase		LF WITH(NOLOCK)
	--				WHERE			LF.TU_CodLegajo				= A.Legajo
	--				AND				LF.TC_CodContexto			= A.Contexto
	--				ORDER BY		LF.TF_Fase					DESC
	--			) B
  
     select 'incio dato final '+(CONVERT( VARCHAR(24), GETDATE(), 121))
	INSERT  INTO @DatosFinal
			SELECT * FROM @Datos D
			WHERE     CodigoFase=ISNULL((SELECT Valorcampo FROM @L_Where WHERE NombreCampo='CodigoFase'),D.CodigoFase)
				  and Descripcion like '%'+ ISNULL((SELECT Valorcampo FROM @L_Where WHERE NombreCampo='Descripcion'),D.Descripcion)+'%'

	select 'fin datofinal '+(CONVERT( VARCHAR(24), GETDATE(), 121))
   	--Agregar descripcion de catalogos
	UPDATE		A
	SET			A.Fase					= B.TC_Descripcion
	FROM		@DatosFinal						A
	INNER JOIN	Catalogo.Fase				B WITH(NOLOCK)
	ON			B.TN_CodFase				= A.CodigoFase
	
	UPDATE		A
	SET			A.Asunto					= B.TC_Descripcion
	FROM		@DatosFinal						A
	INNER JOIN	Catalogo.Asunto				B WITH(NOLOCK)
	ON			B.TN_CodAsunto				= A.CodigoAsunto
	-------------------------------------
    SET @TN_Total =(SELECT count(*) FROM @DatosFinal)
	update @DatosFinal
	set TotalRegistros = @TN_Total
	
	select * from @DatosFinal
	ORDER BY Expediente
	OFFSET (@L_NumeroPagina	-1) * @L_CantidadRegistros ROWS
	FETCH NEXT @L_CantidadRegistros ROWS only
	

END

GO
