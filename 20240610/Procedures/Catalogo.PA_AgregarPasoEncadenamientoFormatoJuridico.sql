SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
-- Autor:				<Xinia Soto V.>
-- Fecha Creación:		<04/11/2021>
-- Descripcion:			<Crear nuevo paso de un encadenamiento de formato jurídico>
-- =========================================================================================================================================
-- Modificación:		<Xinia Soto V. 22/11/2021> Se pasa a varchar(5) la materia
-- =========================================================================================================================================
-- Modificación:		<Rafa Badilla A. 07/04/2022> Se agrega parámetro código de operación trámite
-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_AgregarPasoEncadenamientoFormatoJuridico] 
	@CodTipoOficina		SMALLINT,
	@CodMateria			VARCHAR(5),
	@CodFormatoJuridico	VARCHAR(8),
	@CodOperacionTramite SMALLINT,
	@CodEncadenamiento	INT,
	@Orden				TINYINT
AS
BEGIN

	--Variables locales
	DECLARE @L_CodTipoOficina		SMALLINT	= @CodTipoOficina,
			@L_CodMateria			VARCHAR(5)	= @CodMateria,
			@L_CodFormatoJuridico	VARCHAR(8)	= @CodFormatoJuridico,
			@L_CodOperacionTramite	SMALLINT	= @CodOperacionTramite,
			@L_CodEncadenamiento	INT			= @CodEncadenamiento,
	        @L_Orden				TINYINT		= @Orden

 
	--Aplicación de inserción
	INSERT INTO Catalogo.PasoEncadenamientoFormatoJuridico
	(
		 [TN_CodTipoOficina],					[TC_CodMateria],	[TC_CodFormatoJuridico],	 [TN_CodOperacionTramite],
		 [TN_CodEncadenamientoFormatoJuridico],	[TN_Orden],			[TF_Actualizacion] 
	)
	VALUES
	(
		 @L_CodTipoOficina,		@L_CodMateria,		@L_CodFormatoJuridico,		@L_CodOperacionTramite,
		 @L_CodEncadenamiento,  @L_Orden,			GETDATE()				
	)

END
GO
