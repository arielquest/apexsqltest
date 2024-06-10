SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<13/11/2018>
-- Descripción :			<Permite modificar un archivo sin expediente> 
-- Modificación				<Fabian Sequeira Gamboa> <19/08/2021> <Se modifica la cantidad de caracteres a recibir por placa y boleta>
-- =================================================================================================================================================

CREATE PROCEDURE [ArchivoSinExpediente].[PA_ModificarArchivoSinExpediente]
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

	UPDATE	ArchivoSinExpediente.ArchivoSinExpediente
	SET
		[TC_Condicion]		=	@CondicionD,		
		[TC_BoletaCitacion] =	@BoletaCitacionD,			
		[TC_PlacaVehiculo]	=	@PlacaVehiculoD,			
		[TF_Colision]		=	@FechaColisionD
	WHERE
		[TU_CodArchivo]		=	@CodArchivoD
END
GO
