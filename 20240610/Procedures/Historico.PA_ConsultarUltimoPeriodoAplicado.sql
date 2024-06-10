SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			    <1.0>
-- Autor:				<Oscar Sanchez Hernandez>
-- Fecha Creación:		<28/12/2022>
-- Descripcion:			<Consulta el ultimo periodo de inventario aplicado al expediente o legajo del historial.>
-- Modificado:          <Oscar Sánchez Se modifica para que haga la validacion de si es un expediente o legajo>
-- Modificado:          <23/03/2023><Oscar Sánchez Se modifica para que haga la validacion de horas y minutos en 00:00:00 y 23:59:59>
-- Modificado:          <Aaron Rios - 29-05-2023 - Ajuste por hallazgo en pruebas de carga, bloqueos en tablas, se agrega el WITH (NOLOCK) en las tablas faltantes >
-- =================================================================================================================================================

CREATE   PROCEDURE [Historico].[PA_ConsultarUltimoPeriodoAplicado] 
	@CodigoPeriodo				uniqueidentifier,
	@NumeroExpediente			char(14),
	@CodigoLegajo				uniqueidentifier
AS

BEGIN

	DECLARE	@L_TU_CodigoPeriodo			                uniqueidentifier  = @CodigoPeriodo,
			@L_TC_NumeroExpediente			            char(14)  = @NumeroExpediente,
			@L_TU_CodigoLegajo							UNIQUEIDENTIFIER = @CodigoLegajo

			if @L_TU_CodigoLegajo is not null 
			BEGIN

			--Consulta Legajos
			SELECT 

			 Expediente.PeriodoInventariado.TC_NombrePeriodo as NombrePeriodo,
			 Expediente.PeriodoInventariado.TU_CodPeriodo as CodigoPeriodo

			FROM			Historico.HistoricoInventariado WITH (NOLOCK)
	
			JOIN				Expediente.PeriodoInventariado ON 

								Historico.HistoricoInventariado.TU_CodPeriodo=Expediente.PeriodoInventariado.TU_CodPeriodo
							and Historico.HistoricoInventariado.TU_CodPeriodo = @CodigoPeriodo

							and Historico.HistoricoInventariado.TF_FechaAplicacion >= DATEADD(DAY, DATEDIFF(DAY, '19000101', Expediente.PeriodoInventariado.TF_Fechainicio), '19000101')
							and Historico.HistoricoInventariado.TF_FechaAplicacion  <= DATEADD(DAY, DATEDIFF(DAY, '18991231', Expediente.PeriodoInventariado.TF_FechaFinal ), '19000101')

							and HistoricoInventariado.TU_CodLegajo = @L_TU_CodigoLegajo 
							and HistoricoInventariado.TC_NumeroExpediente = @L_TC_NumeroExpediente

			ORDER BY 		Expediente.PeriodoInventariado.TF_FechaFinal DESC
	
			END
			ELSE
			BEGIN
			--Consulta Expedientes
			SELECT 

			 Expediente.PeriodoInventariado.TC_NombrePeriodo as NombrePeriodo,
			 Expediente.PeriodoInventariado.TU_CodPeriodo as CodigoPeriodo

			FROM			Historico.HistoricoInventariado	WITH (NOLOCK)
	
			JOIN				Expediente.PeriodoInventariado ON 

								Historico.HistoricoInventariado.TU_CodPeriodo=Expediente.PeriodoInventariado.TU_CodPeriodo
							and Historico.HistoricoInventariado.TU_CodPeriodo = @CodigoPeriodo

							and Historico.HistoricoInventariado.TF_FechaAplicacion >= DATEADD(DAY, DATEDIFF(DAY, '19000101', Expediente.PeriodoInventariado.TF_Fechainicio), '19000101')
							and Historico.HistoricoInventariado.TF_FechaAplicacion  <= DATEADD(DAY, DATEDIFF(DAY, '18991231', Expediente.PeriodoInventariado.TF_FechaFinal ), '19000101')

							and HistoricoInventariado.TC_NumeroExpediente = @L_TC_NumeroExpediente

			ORDER BY 		Expediente.PeriodoInventariado.TF_FechaFinal DESC
			END

END

GO
