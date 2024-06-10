SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Versión:			    <1.0>
-- Autor:				<Oscar Sanchez Hernandez>
-- Fecha Creación:		<02/01/2023>
-- Descripcion:			<Consulta el historico de inventariado de un expediente o legajo.>
-- Modificado:          <03/01/2023 Oscar Daniel Sanchez - Se valida si es un expediente o un legajo>
-- =================================================================================================================================================

CREATE   PROCEDURE [Historico].[PA_ConsultarHistoricoInventariado] 

	@NumeroExpediente			char(14),
	@CodigoLegajo				uniqueidentifier
AS

BEGIN

	DECLARE	@L_TC_NumeroExpediente			            char(14)  = @NumeroExpediente,
			@L_TU_CodigoLegajo							UNIQUEIDENTIFIER = @CodigoLegajo

	if @L_TU_CodigoLegajo is null
	BEGIN
	SELECT 

	 Historico.HistoricoInventariado.TU_CodPeriodo as CodigoPeriodo,
	 Historico.HistoricoInventariado.TU_CodLegajo as CodigoLegajo,
	 Historico.HistoricoInventariado.TC_NumeroExpediente as NumeroExpediente,
	 Historico.HistoricoInventariado.TC_DetalleInventariado as DetalleInventariado,
	 Historico.HistoricoInventariado.TF_FechaAplicacion as FechaAplicado,
	 Catalogo.Funcionario.TC_Nombre + ' ' + Catalogo.Funcionario.TC_PrimerApellido + ' ' + Catalogo.Funcionario.TC_SegundoApellido as Funcionario,
	 Expediente.PeriodoInventariado.TC_NombrePeriodo as NombrePeriodo

	FROM			Historico.HistoricoInventariado, Catalogo.Funcionario, Expediente.PeriodoInventariado WITH (NOLOCK)

	WHERE           Historico.HistoricoInventariado.TU_CodPeriodo = Expediente.PeriodoInventariado.TU_CodPeriodo 
				AND Historico.HistoricoInventariado.TC_UsuarioRed =  Catalogo.Funcionario.TC_UsuarioRed
				AND Historico.HistoricoInventariado.TC_NumeroExpediente = @L_TC_NumeroExpediente
				AND Historico.HistoricoInventariado.TU_CodLegajo is null
	
	ORDER BY 		Historico.HistoricoInventariado.TF_FechaAplicacion DESC, Historico.HistoricoInventariado.TC_UsuarioRed DESC
	END
	ELSE
	BEGIN
		SELECT 

	 Historico.HistoricoInventariado.TU_CodPeriodo as CodigoPeriodo,
	 Historico.HistoricoInventariado.TU_CodLegajo as CodigoLegajo,
	 Historico.HistoricoInventariado.TC_NumeroExpediente as NumeroExpediente,
	 Historico.HistoricoInventariado.TC_DetalleInventariado as DetalleInventariado,
	 Historico.HistoricoInventariado.TF_FechaAplicacion as FechaAplicado,
	 Catalogo.Funcionario.TC_Nombre + ' ' + Catalogo.Funcionario.TC_PrimerApellido + ' ' + Catalogo.Funcionario.TC_SegundoApellido as Funcionario,
	 Expediente.PeriodoInventariado.TC_NombrePeriodo as NombrePeriodo

	FROM			Historico.HistoricoInventariado, Catalogo.Funcionario, Expediente.PeriodoInventariado WITH (NOLOCK)

	WHERE           Historico.HistoricoInventariado.TU_CodPeriodo = Expediente.PeriodoInventariado.TU_CodPeriodo 
				AND Historico.HistoricoInventariado.TC_UsuarioRed =  Catalogo.Funcionario.TC_UsuarioRed
				AND Historico.HistoricoInventariado.TC_NumeroExpediente = @L_TC_NumeroExpediente
				AND Historico.HistoricoInventariado.TU_CodLegajo = @L_TU_CodigoLegajo

	ORDER BY 		Historico.HistoricoInventariado.TF_FechaAplicacion DESC, Historico.HistoricoInventariado.TC_UsuarioRed DESC
	END
END
GO
