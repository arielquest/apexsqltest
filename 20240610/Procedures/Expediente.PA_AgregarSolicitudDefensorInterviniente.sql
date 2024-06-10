SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<14/05/2017>
-- Descripción :			<Permite agregar un registro en [Expediente].[SolicitudDefensorInterviniente]
-- =================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_AgregarSolicitudDefensorInterviniente]
     @CodSolicitudDefensor	Uniqueidentifier,
	 @CodInterviniente		Uniqueidentifier,
	 @Sustitucion			Bit,
	 @Declaro				Bit,
	 @Observaciones			Varchar(255)

	  

As  
	Begin

	
		INSERT INTO [Expediente].[SolicitudDefensorInterviniente]
		(
			[TU_CodSolicitudDefensor],	[TU_CodInterviniente],	[TB_Sustitucion],	[TB_Declaro],
			[TC_Observaciones]
		)
		VALUES
		(
			@CodSolicitudDefensor,		@CodInterviniente,		@Sustitucion,		@Declaro,
			@Observaciones	
		)

 End

  



GO
