SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<16/08/2019>
-- Descripción :			<Permite modificar el estado de un movimiento circulante del legajo> 
-- =================================================================================================================================================
-- Modificación:			<04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ModificarEstadoLegajoMovimientoCirculante]
	@CodigoLegajo				uniqueidentifier,
	@Fecha						datetime2(7),
	@CodEstado					int
AS  
BEGIN  
	UPDATE	Historico.LegajoMovimientoCirculante
	SET		TN_CodEstado				=	@CodEstado
	WHERE	TU_CodLegajo				=	@CodigoLegajo
			AND TF_Fecha				=	@Fecha			
END
GO
