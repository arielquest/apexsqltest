SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<17/03/2017>
-- Descripción:				<Permite agregar un registro a la tabla [Comunicacion].[IntentoComunicacion]> 
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarIntentoComunicacion]
(	
	@CodigoIntento		Uniqueidentifier,
	@CodigoComunicacion Uniqueidentifier,
	@Observaciones		Varchar(150) = Null,
	@FechaIntento		Datetime2,
	@UsuarioRed			Varchar(30)	 = Null,
	@Latitud			float			= Null,
	@Longitud			float			= Null,
	@Positivo			Bit,
	@NombreRecibe		Varchar(150) = Null,
	@FirmaDestinatario  Image        = Null,
	@NombreTestigo		Varchar(150) = Null
)
AS
BEGIN

	Insert Into	[Comunicacion].[IntentoComunicacion]
	(	
		[TU_CodIntento],		[TU_CodComunicacion] ,		[TC_Observaciones],		[TF_FechaIntento],
		[TC_UsuarioRed],		[TB_Positivo],				[TC_NombreRecibe],		[TI_FirmaDestinatario],
		[TC_NombreTestigo],		[TG_UbicacionPuntoVisita]
	)
	Values
	(
		@CodigoIntento,			@CodigoComunicacion,		@Observaciones,			@FechaIntento,
		@UsuarioRed,			@Positivo,					@NombreRecibe,			@FirmaDestinatario,
		@NombreTestigo,			Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null)
	)
END
GO
