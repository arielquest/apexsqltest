SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<03/11/2021>
-- Descripción :			<Validaciones al insertar pasos de encadenamiento de formatos jurídicos> 
-- =================================================================================================================================================
CREATE FUNCTION [Catalogo].[VerificarFormatoJuridicoPasoUnoIgualFormatoDeEncadenamiento]
(@Orden TINYINT,@CodFormatoJuridico VARCHAR(8), @CodEncadenamiento INT)
RETURNS BIT
AS
BEGIN
	DECLARE @Result								BIT			= 1,
			@L_Orden							TINYINT		= @Orden,
			@L_CodFormatoJuridico				VARCHAR(8)	= @CodFormatoJuridico, 
			@L_CodEncadenamiento				INT	= @CodEncadenamiento,
			@L_CodFormatoJuridicoEncadenamiento	VARCHAR(8),
			@L_OrdenUNO							TINYINT

	--Verifica que el formato jurídico del paso uno sea igual al del encadenamiento
	IF(@L_Orden = 1)
	BEGIN
		SELECT	@L_CodFormatoJuridicoEncadenamiento = TC_CodFormatoJuridico 
		FROM	Catalogo.EncadenamientoFormatoJuridico 
		WHERE	TN_CodEncadenamientoFormatoJuridico = @L_CodEncadenamiento 

		IF(@L_CodFormatoJuridico <> ISNULL(@L_CodFormatoJuridicoEncadenamiento,''))
		BEGIN
			SET @Result = 0
		END	
	END
	ELSE
	BEGIN
		--Verifica que exista el paso uno antes de insertar otro paso
		SELECT	@L_OrdenUNO = ISNULL(TN_Orden,0)
		FROM	Catalogo.PasoEncadenamientoFormatoJuridico 
		WHERE	TN_CodEncadenamientoFormatoJuridico = @L_CodEncadenamiento AND
				TN_Orden							= 1

		IF(@L_OrdenUNO <> 1)
		BEGIN
			SET @Result = 0
		END	
	END
	RETURN @Result
END

GO
