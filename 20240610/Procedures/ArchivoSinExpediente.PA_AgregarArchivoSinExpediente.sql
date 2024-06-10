SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<11/10/2018>
-- Descripción :			<Permite agregar un archivo sin expediente> 
-- Modificado por:			<Fabian Sequeira Gamboa>
-- Fecha de creación:		<02/03/2021>
-- Descripción :			<Se cambia el valor de la boleta y la placa> 
-- =================================================================================================================================================

CREATE PROCEDURE [ArchivoSinExpediente].[PA_AgregarArchivoSinExpediente]
	@CodArchivo				uniqueidentifier,
	@Condicion				char(1),
	@BoletaCitacion			varchar(29),
	@PlacaVehiculo			varchar(20),
	@FechaColision			datetime
AS  
BEGIN  
Declare @CodArchivoD		Uniqueidentifier	= @CodArchivo,  
		@CondicionD			Varchar(5)			= @Condicion,  
		@BoletaCitacionD	Varchar(29)			= @BoletaCitacion,  
		@PlacaVehiculoD		Varchar(20)			= @PlacaVehiculo,  
		@FechaColisionD		Datetime2			= @FechaColision  

	INSERT INTO	ArchivoSinExpediente.ArchivoSinExpediente
	(
		TU_CodArchivo,		TC_Condicion,		TC_BoletaCitacion,			TC_PlacaVehiculo,			TF_Colision
	)
	VALUES
	(
		@CodArchivoD,		@CondicionD,			@BoletaCitacionD,			@PlacaVehiculoD,				@FechaColisionD
	)
END
GO
