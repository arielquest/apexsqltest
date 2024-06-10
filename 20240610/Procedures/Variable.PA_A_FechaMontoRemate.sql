SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño.>
-- Create date:					<09/07/2020>
-- Description:					<Traducción de las Variables del PJEditor para obtener el monto y las fechas de remates>
-- NOTA:	Como parametro para @NumeroRemate usar los siguientes valores
--			1. Primer remate
--			2. Segundo remate
--			3. Tercer remate
--			Como parametro para @Salida usar los siguientes valores
--			1. Fecha remate
--			2. Monto remate
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_FechaMontoRemate]
	@NumeroExpediente		As Char(14),
	@Contexto				As VarChar(4),
	@NumeroRemate			As Integer,
	@Salida					As Integer
AS
BEGIN
	DECLARE		@L_NumeroExpediente     As Char(14)     = @NumeroExpediente,
				@L_Contexto             As VarChar(4)   = @Contexto,
				@L_NumeroRemate			As Integer		= @NumeroRemate,
				@L_Salida				As Integer		= @Salida,
				@L_FechaPrimerRemate	As DateTime		= '',
				@L_FechaUltimoRemate	As DateTime		= '',
				@L_IdUltimoRemate		As uniqueidentifier;

	--Que estado debe tener el remate para poder listarse

	--Se obtiene la fecha del ultimo remate
	Set			@L_FechaUltimoRemate	=	(Select		MAX(C.TF_FechaInicio)
											From		Agenda.Evento					A With(NoLock)
											INNER JOIN	Agenda.FechaEvento				C With(NoLock)
											ON			A.TU_CodEvento					= C.TU_CodEvento
											AND			A.TN_CodTipoEvento				= 5
											AND			A.TN_CodEstadoEvento			= 1
											INNER JOIN	Expediente.ExpedienteDetalle	B With(NoLock)
											ON			A.TC_NumeroExpediente			= B.TC_NumeroExpediente
											And			B.TC_CodContexto				= @L_Contexto
											Where		A.TC_NumeroExpediente			= @L_NumeroExpediente)

	--Se obtiene el id del ultimo remate
	Set			@L_IdUltimoRemate		=	(Select		TU_CodEvento
											From		Agenda.FechaEvento
											Where		TF_FechaInicio					= @L_FechaUltimoRemate)

	--Se obtiene la fecha del primer remate
	Set			@L_FechaPrimerRemate	=	(Select		MIN(TF_FechaInicio)
											From		Agenda.FechaEvento
											Where		TU_CodEvento					= @L_IdUltimoRemate)

	If @L_Salida = 1
		SELECT		CASE
					When @NumeroRemate = 1 Then		@L_FechaPrimerRemate
					When @NumeroRemate = 2 Then		(Select Top(1)	TF_FechaInicio
													From	Agenda.FechaEvento
													Where	TU_CodEvento	= @L_IdUltimoRemate
													And		TF_FechaInicio	> @L_FechaPrimerRemate
													And		TF_FechaInicio	< @L_FechaUltimoRemate)
					When @NumeroRemate = 3 Then		@L_FechaUltimoRemate
				End As Salida
	Else
		SELECT		CASE
					When @NumeroRemate = 1 Then		(Select	TN_MontoRemate
													From	Agenda.FechaEvento
													Where	TU_CodEvento	= @L_IdUltimoRemate
													And		TF_FechaInicio	= @L_FechaPrimerRemate)
					When @NumeroRemate = 2 Then		(Select	Top(1) TN_MontoRemate
													From	Agenda.FechaEvento
													Where	TU_CodEvento	= @L_IdUltimoRemate
													And		TF_FechaInicio	> @L_FechaPrimerRemate
													And		TF_FechaInicio	< @L_FechaUltimoRemate)
					When @NumeroRemate = 3 Then		(Select	TN_MontoRemate
													From	Agenda.FechaEvento
													Where	TU_CodEvento	= @L_IdUltimoRemate
													And		TF_FechaInicio	= @L_FechaUltimoRemate)
				End As Salida

END
GO
