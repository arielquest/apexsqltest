SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<16/08/2019>
-- Descripción :			<Permite agregar un registro al historico de ExpedienteMovimientoCirculante> 
-- =================================================================================================================================================
-- Modificación:			<04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ModificarEstadoExpedienteMovimientoCirculante]
	@NumeroExpediente			varchar(14),
	@Fecha						datetime2(7),
	@CodEstado					int
AS  
BEGIN  
	UPDATE Historico.ExpedienteMovimientoCirculante
	SET
		TN_CodEstado				=	@CodEstado
	WHERE
		TC_NumeroExpediente			=	@NumeroExpediente
		AND TF_Fecha				=	@Fecha			
END
GO
