SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<05/06/2019>
-- Descripción :			<Permite excluir un archivo de un legajo y sigue en el expediente> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ExcluirLegajoArchivo]
	@CodigoArchivo uniqueidentifier,
	@CodigoLegajo uniqueidentifier
AS  
BEGIN  
		DELETE FROM		Expediente.LegajoArchivo 
		WHERE			TU_CodArchivo				= @CodigoArchivo
		AND				TU_CodLegajo				= @CodigoLegajo
END
GO
