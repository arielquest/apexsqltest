SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<16/06/2022>
-- Descripción:			<Permite agregar un registro en la tabla: EncadenamientoTramiteMateriaOficina.>
-- ==================================================================================================================================================================================
-- Modificado  por:			<Jefferson Parker Cortes>
-- Fecha de creación:	<27/06/2022>
-- Se agrega el campo actualizacion
-- ==================================================================================================================================================================================
CREATE    PROCEDURE	[Catalogo].[PA_AgregarEncadenamientoTramiteMateriaOficina]

	@CodEncadenamientoTramite UNIQUEIDENTIFIER,
	@CodMateria					VARCHAR(5),
	@CodTipoOficina				SMALLINT,
	@Actualizacion		       DateTime2(7)

AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEncadenamientoTramite		UNIQUEIDENTIFIER	= @CodEncadenamientoTramite,
			@L_TC_CodMateria					VARCHAR(5)			= @CodMateria,
			@L_TN_CodTipoOficina				SMALLINT			= @CodTipoOficina,
			@L_TF_Actualizacion					dateTime2(7)		= @Actualizacion

	--Cuerpo
	INSERT INTO	Catalogo.EncadenamientoTramiteMateriaOficina	WITH (ROWLOCK)
	(
		TU_CodEncadenamientoTramite,		TC_CodMateria,			TN_CodTipoOficina	, TF_Actualizacion			
	)
	VALUES
	(
		@L_TU_CodEncadenamientoTramite,		@L_TC_CodMateria,		@L_TN_CodTipoOficina	, @L_TF_Actualizacion	
	)
END
GO
