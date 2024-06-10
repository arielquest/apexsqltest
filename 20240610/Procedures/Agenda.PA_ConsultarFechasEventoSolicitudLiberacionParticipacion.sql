SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Navarrete Alvarez>
-- Fecha de creación:		<15/05/2018>
-- Descripción:				<Obtiene las fechas del evento de para la solicitud de liberación de participación> 
--=============================================================================================

CREATE PROCEDURE  [Agenda].[PA_ConsultarFechasEventoSolicitudLiberacionParticipacion] 
  @CodigoEvento uniqueidentifier,
  @FechaActual	Datetime2 
As
Begin
 	Select	FE.TU_CodFechaEvento	As	Codigo,		FE.TF_FechaInicio	As	FechaInicio,
			FE.TF_FechaFin			As	FechaFin				
	From	Agenda.FechaEvento		As	FE
 
	WHERE TU_CodEvento		=	@CodigoEvento
	And	FE.TB_Cancelada		=	0
	And	FE.TF_FechaInicio	>=	@FechaActual
End
GO
