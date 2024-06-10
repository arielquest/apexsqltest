SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<07/11/2018>
-- Descripción :			<Permite agregar un registro al historico de ArchivoSolicitudDesAcumulación> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarArchivoSolicitudDesAcumulacion]
	@CodSolicitud				uniqueidentifier,
	@CodArchivo					uniqueidentifier,
	@ModoSeleccion				Char(1)

AS  
BEGIN  
	INSERT INTO	Historico.ArchivoSolicitudDesacumulacion
	(
		TU_CodSolicitud,
		TU_CodArchivo,
		TC_ModoSeleccion
	)
	VALUES
	(
		@CodSolicitud,				
		@CodArchivo,			
		@ModoSeleccion						
	)
END
GO
