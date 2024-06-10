SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

	-- =================================================================================================================================================
	-- Versión:					<1.0>
	-- Creado por:				<Mario Camacho Flores>
	-- Fecha de creación:		<03/01/2023>
	-- Descripción :			<Permite agregar los archivos de un seguimiento> 
	-- =================================================================================================================================================
 
 CREATE   PROCEDURE [Expediente].[PA_AgregarSeguimientoArchivo]
	

		@CodArchivo uniqueidentifier,
		@CodSeguimiento uniqueidentifier,
		@NumeroExpediente char(14)

 AS
 BEGIN

	INSERT INTO [Expediente].[SeguimientoArchivo]
	( 
		[TU_CodArchivo],
		[TU_CodSeguimiento],
		[TC_NumeroExpediente]
	)
	VALUES 
	(	
		@CodArchivo,
		@CodSeguimiento,
		@NumeroExpediente	
	);
 
 END 
GO
