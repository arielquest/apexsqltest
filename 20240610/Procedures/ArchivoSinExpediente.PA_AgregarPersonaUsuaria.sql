SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<10/10/2018>
-- Descripción :			<Permite agregar una persona usuaria para un archivo sin expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [ArchivoSinExpediente].[PA_AgregarPersonaUsuaria]
	@CodArchivo				uniqueidentifier,
	@TipoIdentificacion		smallint,
	@Identificacion			varchar(21),
	@Nombre					varchar(50),
	@PrimerApellido			varchar(50),
	@SegundoApellido		varchar(50),
	@TipoFirma				char(1),
	@FechaFirma				datetime,
	@DescripcionFirma		varchar(50)
AS  
BEGIN  

	INSERT INTO	ArchivoSinExpediente.PersonaUsuaria
	(
		TU_CodArchivo,		TN_CodTipoIdentificacion,	TC_Identificacion,		TC_Nombre,		TC_PrimerApellido,		TC_SegundoApellido,
		TC_TipoFirma,		TC_DescripcionFirma,		TF_Firma
	)
	VALUES
	(
		@CodArchivo,		@TipoIdentificacion,		@Identificacion,		@Nombre,		@PrimerApellido,		@SegundoApellido,
		@TipoFirma,			@DescripcionFirma,			@FechaFirma
	)
END
GO
