SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<30/11/2016>
-- Descripción:				<Permite agregar un registro a Agenda.JornadaTrabajoEspecial.>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_AgregarJornadaTrabajoEspecial]
	@CodPuestoTrabajo		varchar(14),
	@DiaSemana				char(1),
	@HoraInicio				time,
	@HoraFin				time,
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
As  
Begin  
	Insert Into [Agenda].[JornadaTrabajoEspecial]
           ([TC_CodPuestoTrabajo]
           ,[TC_DiaSemana]
           ,[TF_HoraInicio]
           ,[TF_HoraFin]
           ,[TF_Inicio_Vigencia]
           ,[TF_Fin_Vigencia])
     Values
           (@CodPuestoTrabajo
           ,@DiaSemana
           ,@HoraInicio
           ,@HoraFin
           ,@FechaActivacion
           ,@FechaDesactivacion);
End


GO
