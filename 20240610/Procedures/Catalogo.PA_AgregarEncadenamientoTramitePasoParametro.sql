SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<16/06/2022>
-- Descripción:			<Permite agregar un registro en la tabla: EncadenamientoTramitePasoParametro.>
-- ==================================================================================================================================================================================
-- Modificado por:			<Jefferson Parker Cortes>
-- Fecha de creación:	<27/06/2022>
-- Descripción:			<Se agrega campo CodEncadenamientoTramitePaso para relacionar el parametro con el paso >
-- ==================================================================================================================================================================================
CREATE      PROCEDURE	[Catalogo].[PA_AgregarEncadenamientoTramitePasoParametro]
	@CodOperacionTramiteParametro			SMALLINT,
	@CodEncadenamientoTramitePaso			uniqueidentifier,
	@CodMateria								VARCHAR(5),
	@CodTipoOficina							SMALLINT,
	@Valor									VARCHAR(255)	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TN_CodOperacionTramiteParametro				SMALLINT			= @CodOperacionTramiteParametro,
	        @L_TU_CodEncadenamientoTramitePaso				uniqueidentifier	= @CodEncadenamientoTramitePaso,
			@L_TC_CodMateria								VARCHAR(5)			= @CodMateria,
			@L_TN_CodTipoOficina							SMALLINT			= @CodTipoOficina,
			@L_TC_Valor										VARCHAR(255)		= @Valor

	--Cuerpo
	INSERT INTO	Catalogo.EncadenamientoTramitePasoParametro	WITH (ROWLOCK)
	(
		TN_CodOperacionTramiteParametro,		TU_CodEncadenamientoTramitePaso ,		TC_CodMateria,		TN_CodTipoOficina,				
		TC_Valor						
	)
	VALUES
	(
		@L_TN_CodOperacionTramiteParametro,	@L_TU_CodEncadenamientoTramitePaso, 	@L_TC_CodMateria,	@L_TN_CodTipoOficina,			
		@L_TC_Valor						
	)
END
GO
