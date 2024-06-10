SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:			<Jonathan Aguilar Navarro>
-- Fecha Creación:	<21/01/2021>
-- Descripcion:		<Validar que existe un legajo en SIAGPJ>
-- =================================================================================================================================================
-- Modificación:	<22/02/2021><Karol Jiménez S.><Se ajusta validación para identificar si ya existe un legajo en SIAGPJ>
-- =================================================================================================================================================
-- Modificación:	<28/09/2022><Josué Quirós Batista><Se agregan los parámetros de código de asunto y despacho destino para identificar el tipo de 
--					legajo específico>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ExisteLegajo] 
	@Carpeta			VARCHAR(14),
	@NumeroExpediente	VARCHAR(14),
	@CodAsunto			Int,
	@DespachoDestino	VARCHAR(4)
As
BEGIN

	DECLARE @L_Carpeta				VARCHAR(14) = @Carpeta,
			@L_NumeroExpediente		VARCHAR(14) = @NumeroExpediente,
			@L_CodAsunto			Int			= @CodAsunto,
			@L_DespachoDestino		VARCHAR(4)  = @DespachoDestino,
			@L_TipoRecurso			Int			= 0,
			@L_TipoSolicitud		Int			= 0


	Set	 @L_TipoRecurso =  Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoRecurso', @L_DespachoDestino)
	Set	 @L_TipoSolicitud =  Itineracion.FN_ConsultarValorDefectoConfiguracion('C_AsuntoTipoSolicitud', @L_DespachoDestino)
	
	If (@L_CodAsunto = @L_TipoRecurso Or  @L_CodAsunto = @L_TipoSolicitud)
	Begin
			
		SELECT		Top 1 *					
		FROM		Expediente.Legajo					A With(NoLock)
		Inner  Join Expediente.LegajoDetalle			B With(NoLock)
		ON			B.TU_CodLegajo						= A.TU_CodLegajo
		WHERE		A.CARPETA							= @L_Carpeta
		AND			A.TC_NumeroExpediente				= @L_NumeroExpediente
		And			B.TN_CodAsunto						=  @L_CodAsunto
		
	End
	Else  
	Begin

		SELECT		Top 1 *					
		FROM		Expediente.Legajo					A With(NoLock)
		Inner  Join Expediente.LegajoDetalle			B With(NoLock)
		ON			B.TU_CodLegajo						= A.TU_CodLegajo
		WHERE		A.CARPETA							= @L_Carpeta
		AND			A.TC_NumeroExpediente				= @L_NumeroExpediente
		And			B.TN_CodAsunto						Not In (@L_TipoRecurso,@L_TipoSolicitud)

	End







END

GO
