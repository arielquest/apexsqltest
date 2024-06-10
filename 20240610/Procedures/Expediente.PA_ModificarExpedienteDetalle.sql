SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================================================================
-- Autor:			<Roger Lara>
-- Fecha Creación:	<26/10/2015>
-- Descripcion:		<Modifica un detalle de expediente asociado a un legajo.>
-- ======================================================================================================================================
-- Modificacion:	<8/12/2015><Gerardo Lopez> <Se cambia tipo de dato a codmoneda a tinyint>
-- Modificado por:	<Sigifredo Leitón Luna.>
-- Fecha:			<13/01/2016>
-- Descripción:		<Se realiza cambio para autogenerar el consecutivo de tipo de cuantía - item 5630.> 
-- Modificado por:	<Donald Vargas Zúñiga>
-- Fecha:			<02/12/2016>
-- Descripción:		<Se corrige el nombre del campo TC_CodMoneda, TC_CodPrioridad, TC_CodTipoCuantia y TC_CodTipoViabilidad a TN_CodMoneda, TN_CodPrioridad, TN_CodTipoCuantia y TN_CodTipoViabilidad de acuerdo al tipo de dato>
-- Modificación		<Jonathan Aguilar><26/04/2018> Se modifican los campos TC_CodOficina por TC_CodContexto y TC_CodOficinaProcedencia por TC_CodContextoProcedencia
-- Modificación:	<Jonathan Aguilar Navarro> <18/03/2019> <Se  modifica con respecto a los cambios de Creacion de expediente, tabla ExpedienteDealle>
-- =============================================

CREATE PROCEDURE [Expediente].[PA_ModificarExpedienteDetalle]	
	@NumeroExpediente		char(14),
	@Contexto				varchar(4),	
	@FechaEntrada			datetime2,
	@Clase					int,
	@Proceso				int,
	@Fase					int,
	@ContextoProcedencia	varchar(4),
	@GrupoTrabajo			int,
	@Habilitado				bit,
	@DocumentosFisicos		bit

AS
BEGIN
	
	Update	Expediente.ExpedienteDetalle 
	Set		TC_CodContexto				=	@Contexto				,	 
			TF_Entrada					=	@FechaEntrada			,
			TN_CodClase					=	@Clase					,
			TN_CodProceso				=	@Proceso				,
			TN_CodFase					=	@Fase					,
			TC_CodContextoProcedencia	=	@ContextoProcedencia	,
			TN_CodGrupoTrabajo			=	@GrupoTrabajo			,
			TB_Habilitado				=	@Habilitado				,
			TB_DocumentosFisicos		=	@DocumentosFisicos		,
			TF_Actualizacion			=	Getdate()
	Where	TC_NumeroExpediente			=	@NumeroExpediente
	and		TC_CodContexto				=	@Contexto

	END


GO
