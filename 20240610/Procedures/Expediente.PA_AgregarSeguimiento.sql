SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

	-- =================================================================================================================================================
	-- Versión:					<1.0>
	-- Creado por:				<Mario Camacho Flores>
	-- Fecha de creación:		<03/01/2023>
	-- Descripción :			<Permite agregar un seguimiento> 
	-- =================================================================================================================================================
 
 CREATE   PROCEDURE [Expediente].[PA_AgregarSeguimiento]
	
		@CodSeguimiento uniqueidentifier,
        @CodInstitucion uniqueidentifier,
		@CodComunicacion uniqueidentifier,
        @NumeroExpediente char(14),
		@CodPuestoTrabajo uniqueidentifier,
		@UsuarioRed varchar(30),
        @Plazo int, 
        @TipoEnvio char(2),
        @Estado int,
		@CodContexto varchar(4),
		@CodMateria varchar(5),
		@CodTipoOficina smallint
 AS
 BEGIN

	INSERT INTO [Expediente].[Seguimiento]
	( 
		[TU_CodSeguimiento],			[TU_CodInstitucion],				[TU_CodComunicacion],
		[TC_NumeroExpediente],  		[TU_CodPuestoTrabajo],			    [TC_UsuarioRed],
		[TF_FechaRegistro],     		[TN_Plazo],						    [TF_FechaVencimiento],
		[TC_TipoEnvio],             	[TN_Estado],						[TC_CodContexto],
		[TC_CodMateria],				[TN_CodTipoOficina]
	)
	VALUES 
	(	
		@CodSeguimiento,				@CodInstitucion,					@CodComunicacion,
		@NumeroExpediente,  		    @CodPuestoTrabajo,				    @UsuarioRed,
		GetDate(), 		                @Plazo,							    dateadd(day, @Plazo,GETDATE()),		
		@TipoEnvio,		                @Estado,							@CodContexto,
		@CodMateria,					@CodTipoOficina
	);
 
 END 
GO
