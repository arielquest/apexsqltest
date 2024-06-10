SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite eliminar un cierre estadístico de una oficina.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Sistema].[PA_EliminarCierreEstadistico]  
	@CodOficina varchar(4),
	@Mes smallint,
	@Anno smallint
AS 
BEGIN
	DELETE FROM Sistema.CierreEstadistico 
	WHERE		TC_CodOficina	= @CodOficina   
	AND			TN_Mes			= @Mes 
	And			TN_Anno			= @Anno
END
GO
