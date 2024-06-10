SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Eymer Francisco Martinez Hernandez>
-- Fecha de creación:		<17/05/2023>
-- Descripción:				<Obtiene todos los eventos ligados al expediente o legajo> 
-- ============================================================================================================================
--	Modificación:			<01/06/2023> <Eymer Francisco Martinez Hernandez> <Se modifica para obtener el estado del evento> 
-- ============================================================================================================================
CREATE   PROCEDURE  [Agenda].[PA_ConsultarEventosExpedienteLegajo] 
 @NumeroExpediente VARCHAR(14),
 @CodLegajo UNIQUEIDENTIFIER = NULL
AS
BEGIN

	IF @CodLegajo IS NULL

	BEGIN

		WITH
		PrimerasFechas
		AS
		(
			SELECT		MIN(TF_FechaInicio) AS FechaInicio,	TU_CodEvento
			FROM		Agenda.FechaEvento WITH(NOLOCK)						
			GROUP BY	TU_CodEvento 
		)

		SELECT 
				Eve.TU_CodEvento					AS Codigo,
				Eve.TC_CodContexto	            	AS CodContexto,		
				Eve.TC_Descripcion					AS Descripcion ,
				Eve.TC_Titulo		                AS Titulo,
				Eve.TC_NumeroExpediente,
				Eve.TU_CodLegajo,
				PF.FechaInicio						AS FechaInicio,
				'SplitTipoEvento'	                AS SplitTipoEvento,	
				Tipo.TN_CodTipoEvento				AS Codigo, 
				Tipo.TC_DescripciOn					AS Descripcion,
				'SplitEstadoEvento'					AS SplitEstadoEvento,
				Estado.TN_CodEstadoEvento			AS Codigo,
				Estado.TC_Descripcion				AS Descripcion

				
	  
		FROM		Agenda.Evento							  AS Eve WITH(NOLOCK)	 
		INNER JOIN  Catalogo.TipoEvento						  AS Tipo WITH(NOLOCK)
		ON          Tipo.TN_CodTipoEvento                     =  Eve.TN_CodTipoEvento
		INNER JOIN  Catalogo.EstadoEvento						AS Estado WITH(NOLOCK)
		ON			Estado.TN_CodEstadoEvento					= Eve.TN_CodEstadoEvento
		INNER JOIN  PrimerasFechas							  AS PF WITH(NOLOCK)
		ON			PF.TU_CodEvento							  =  Eve.TU_CodEvento	
		
															  
		WHERE		Eve.TC_NumeroExpediente			=@NumeroExpediente 
		AND			Eve.TU_CodLegajo				IS NULL

	END
	ELSE
    BEGIN

		WITH
		PrimerasFechas
		AS
		(
			SELECT		MIN(TF_FechaInicio) AS FechaInicio,	TU_CodEvento
			FROM		Agenda.FechaEvento WITH(NOLOCK)						
			GROUP BY	TU_CodEvento 
		)

		SELECT 
				Eve.TU_CodEvento					AS Codigo,
				Eve.TC_CodContexto	            	AS CodContexto,		
				Eve.TC_Descripcion					AS Descripcion ,
				Eve.TC_Titulo		                AS Titulo,
				Eve.TC_NumeroExpediente,
				Eve.TU_CodLegajo,
				PF.FechaInicio						AS FechaInicio,
				'SplitTipoEvento'	                AS SplitTipoEvento,	
				Tipo.TN_CodTipoEvento				AS Codigo, 
				Tipo.TC_DescripciOn					AS Descripcion,
				'SplitEstadoEvento'					AS SplitEstadoEvento,
				Estado.TN_CodEstadoEvento			AS Codigo,
				Estado.TC_Descripcion				AS Descripcion
				
	  
		FROM		Agenda.Evento							  AS Eve WITH(NOLOCK)	 
		INNER JOIN  Catalogo.TipoEvento						  AS Tipo WITH(NOLOCK)
		ON          Tipo.TN_CodTipoEvento                     =  Eve.TN_CodTipoEvento
		INNER JOIN  Catalogo.EstadoEvento						AS Estado WITH(NOLOCK)
		ON			Estado.TN_CodEstadoEvento					= Eve.TN_CodEstadoEvento
		INNER JOIN  PrimerasFechas							  AS PF WITH(NOLOCK)
		ON			PF.TU_CodEvento							  =  Eve.TU_CodEvento		
															  
		WHERE		Eve.TC_NumeroExpediente			=@NumeroExpediente 
		AND			Eve.TU_CodLegajo				=@CodLegajo
	END
END
GO
