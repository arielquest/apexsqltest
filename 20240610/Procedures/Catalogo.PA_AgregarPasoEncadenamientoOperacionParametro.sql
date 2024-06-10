SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =========================================================================================================================================
-- Autor:				<Isaac Dobles Mata.>
-- Fecha Creación:		<26/04/2022>
-- Descripcion:			<Agregar valores de parámetros a una operación dentro de un paso de Encadenamiento>
-- =========================================================================================================================================

CREATE     PROCEDURE [Catalogo].[PA_AgregarPasoEncadenamientoOperacionParametro] 
	@CodOperacionTramiteParametro					smallint,
	@CodEncadenamientoFormatoJuridico				int,
	@Orden											tinyint,
	@Valor											varchar(255)
AS
BEGIN

	--Variables locales
	DECLARE @L_CodOperacionTramiteParametro			smallint		= @CodOperacionTramiteParametro,
			@L_CodEncadenamientoFormatoJuridico		int				= @CodEncadenamientoFormatoJuridico,
			@L_Orden								tinyint			= @Orden,
			@L_Valor								varchar(255)	= @Valor


	--Aplicación de inserción
	INSERT INTO [Catalogo].[PasoEncadenamientoOperacionParametro]
	(
		[TN_CodOperacionTramiteParametro],					
		[TN_CodEncadenamientoFormatoJuridico],	
		[TN_Orden],	
		[TC_Valor]
	)
	VALUES
	(
		@L_CodOperacionTramiteParametro,		
		@L_CodEncadenamientoFormatoJuridico,		
		@L_Orden,		
		@L_Valor
	)

END
GO
