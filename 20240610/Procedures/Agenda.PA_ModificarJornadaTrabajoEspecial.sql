SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<30/11/2016>
-- Descripción :			<Permite modifcar un registro de Agenda.JornadaTrabajoEspecial.>
-- =================================================================================================================================================
CREATE PROCEDURE [Agenda].[PA_ModificarJornadaTrabajoEspecial]
	@CodJornadaTrabajo		smallint,
	@CodPuestoTrabajo		varchar(14),
	@DiaSemana				char(1),
	@HoraInicio				time,
	@HoraFin				time,
	@FechaDesactivacion		datetime2
As  
Begin

	Update [Agenda].[JornadaTrabajoEspecial]
	   Set [TC_CodPuestoTrabajo]		= @CodPuestoTrabajo
		  ,[TC_DiaSemana]				= @DiaSemana
		  ,[TF_HoraInicio]				= @HoraInicio
		  ,[TF_HoraFin]					= @HoraFin
		  ,[TF_Fin_Vigencia]			= @FechaDesactivacion
	 Where [TN_CodJornadaTrabajo]		= @CodJornadaTrabajo;

End


GO
