SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<18/05/2021>
-- Descripción :			<Consulta de historico de reparto> 
-- Modificado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<20/05/2021>
-- Descripción :			<Se cambia el filtro de oficina a contexto> 
-- Fecha de modificación    <24/05/2021>
-- Modificado por:			<Johan Acosta Ibañez>
-- Descripción :			<Se modifica el procedimiento para agregar los campos de TC_Prioridad, TC_UsuarioRed, TN_CodUbicacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoReparto]       
	@CodigoCriterio				uniqueidentifier = Null,
	@CodigoContexto				varchar(4),
	@NumeroExpediente			varchar(14),
	@CodigoLegajo				uniqueidentifier = Null
AS  
BEGIN  
	Declare 
			@L_CodCriterioReparto	uniqueidentifier	=	@CodigoCriterio, 
			@L_CodigoContexto		varchar(4)			=	@CodigoContexto,
			@L_NumeroExpediente		varchar(14)			=	@NumeroExpediente,
			@L_CodigoLegajo			uniqueidentifier	=	@CodigoLegajo

	If(@L_CodigoLegajo IS NULL)
	BEGIN
		Select	TU_CodBitacora,
				TC_CodOficina				As	CodigoOficina,
				TC_CodContexto				As	CodigoContexto,
				TC_NumeroExpediente			As	NumeroExpediente,
				TU_CodLegajo				As	CodigoLegajo,
				TN_CodTipoPuestoTrabajo		As	CodigoTipoPuestoTrabajo,
				TC_CodPuestoTrabajo			As	CodigoPuestoTrabajo,
				TF_Fecha					As	Fecha,
				TC_Accion					As	Accion,
				TC_Motivo					As	Motivo,
				TC_ValorAtributos			As	ValorAtributos,
				TU_CodCriterio				As	CodigoCriterio,
				TC_UsuarioRed				As	UsuarioRed,
				'split'						As	split,
				TC_Prioridad				As	Prioridad
		From	Historico.HistoricoReparto	With(NoLock)
		Where	TU_CodCriterio				=	Coalesce(@L_CodCriterioReparto, TU_CodCriterio)
		And		TC_CodContexto				=	@L_CodigoContexto
		And		TC_NumeroExpediente			=	@L_NumeroExpediente
		And		TU_CodLegajo				Is	Null
		Order by TF_Fecha Desc
	END
	ELSE
	BEGIN
		Select	TU_CodBitacora,
				TC_CodOficina				As	CodigoOficina,
				TC_CodContexto				As	CodigoContexto,
				TC_NumeroExpediente			As	NumeroExpediente,
				TU_CodLegajo				As	CodigoLegajo,
				TN_CodTipoPuestoTrabajo		As	CodigoTipoPuestoTrabajo,
				TC_CodPuestoTrabajo			As	CodigoPuestoTrabajo,
				TF_Fecha					As	Fecha,
				TC_Accion					As	Accion,
				TC_Motivo					As	Motivo,
				TC_ValorAtributos			As	ValorAtributos,
				TU_CodCriterio				As	CodigoCriterio,
				TC_UsuarioRed				As	UsuarioRed,
				'split'						As	split,
				TC_Prioridad				As	Prioridad
		From	Historico.HistoricoReparto	With(NoLock)
		Where	TU_CodCriterio				=	Coalesce(@L_CodCriterioReparto, TU_CodCriterio)
		And		TC_CodContexto				=	@L_CodigoContexto
		And		TC_NumeroExpediente			=	@L_NumeroExpediente
		And		TU_CodLegajo				=	@L_CodigoLegajo
		Order by TF_Fecha Desc
	END
END



GO
