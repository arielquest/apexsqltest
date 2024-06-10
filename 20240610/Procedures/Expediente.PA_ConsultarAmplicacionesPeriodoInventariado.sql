SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			    <1.0>
-- Autor:				<Aarón Ríos Retana>
-- Fecha Creación:		<22/12/2022>
-- Descripcion:			<Obtiene todas las amplicaciones de un periodo de inventariado.>
-- Modificado:          <Aaron Rios Retana - 29-05-2023 - Ajuste por hallazgo en pruebas de carga, bloqueos en tablas, se agrega el WITH (NOLOCK) en las tablas faltantes >
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarAmplicacionesPeriodoInventariado] 
	@CodigoPeriodo				uniqueidentifier
AS

BEGIN

	DECLARE	@L_CodigoPeriodo	uniqueidentifier  = @CodigoPeriodo

	SELECT 

	 PIA.TU_CodAmpliacion																AS CodigoAmplicacion,
	 PIA.TC_Justificacion																AS Justificacion,
     PIA.TF_FechaAplicacion																AS FechaAplicacion,
	 PIA.TF_FechaFinalAnterior															AS FechaAnterior,
	 'SPLIT'																			AS SplitFuncionario,
	 FUN.TC_Nombre + ' ' +	FUN.TC_PrimerApellido	+ ' ' +	FUN.TC_SegundoApellido		AS Funcionario

	FROM			Expediente.PeriodoInventarioAmpliacion		AS	PIA WITH (NOLOCK)
	INNER JOIN		Catalogo.Funcionario						AS	FUN WITH (NOLOCK)
	ON				PIA.TC_UsuarioRed							= FUN.TC_UsuarioRed
	
	WHERE			PIA.TU_CodPeriodo				=		@L_CodigoPeriodo

	ORDER BY		PIA.TF_FechaAplicacion

END
GO
