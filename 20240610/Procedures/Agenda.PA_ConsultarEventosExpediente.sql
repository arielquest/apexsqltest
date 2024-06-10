SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ailyn López>
-- Fecha de creación:		<28/05/2018>
-- Descripción:             <Este sp obtiene los eventos de un legajo>
-- =========================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<16/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente, 
--							así como para renombrar la parte del nombre del SP de Legajo a Expediente, para 
--							que concuerde>
-- =========================================================================================================
CREATE Procedure  [Agenda].[PA_ConsultarEventosExpediente] 
 @NumeroExpediente	Char(14) = null

AS
BEGIN
		;WITH
		PrimerasFechas
		AS
		(
			SELECT		Min(TF_FechaInicio) AS FechaInicio,	TU_CodEvento
			FROM		Agenda.FechaEvento WITH(NOLOCK)
			WHERE		TF_FechaInicio >=  GetDate()						
			GROUP BY	TU_CodEvento 
		)

		SELECT 
					E.TC_NumeroExpediente			As NumeroExpediente,	E.TU_CodEvento			AS Codigo,
					E.TC_Descripcion				As Descripcion ,	E.TC_Titulo				AS Titulo,
					PF.FechaInicio					As FechaInicio,		'SplitTipoEvento'	    As SplitTipoEvento,				
					Tipo.TN_CodTipoEvento			As Codigo,          Tipo.TC_DescripciOn		As Descripcion 														
	  
		FROM		Agenda.Evento					As E	WITH(NOLOCK)
		INNER JOIN  Catalogo.TipoEvento				As Tipo WITH(NOLOCK)
		ON          Tipo.TN_CodTipoEvento           =  E.TN_CodTipoEvento
		INNER JOIN  PrimerasFechas					As PF
		ON			PF.TU_CodEvento					=  E.TU_CodEvento
		
		WHERE		E.TC_NumeroExpediente			=  @NumeroExpediente

		ORDER BY	(FechaInicio) Asc

END
GO
