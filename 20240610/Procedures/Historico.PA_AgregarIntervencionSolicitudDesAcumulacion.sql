SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<06/11/2018>
-- Descripción :			<Permite agregar un registro al historico de IntervinienteSolicitudDesAcumulación> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarIntervencionSolicitudDesAcumulacion]
	@CodSolicitud				uniqueidentifier,
	@CodInterviniente			uniqueidentifier,
	@ModoSeleccion				Char(1)

AS  
BEGIN  
	INSERT INTO	Historico.IntervinienteSolicitudDesacumulacion
	(
		TU_CodSolicitud,
		TU_CodInterviniente,
		TC_ModoSeleccion
	)
	VALUES
	(
		@CodSolicitud,				
		@CodInterviniente,			
		@ModoSeleccion						
	)
END
GO
