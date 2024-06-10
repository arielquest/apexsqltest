SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<05/09/2019>
-- Descripción :			<Permite Agregar un nuevo Tipo de itineración> 
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <21/09/2020> <Se modifica el nombre de los campos fecha para que cumplan con el estándar.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoItineracion]
	@Descripcion	VARCHAR(255),
	@InicioVigencia DATETIME2,
	@FinVigencia	DATETIME2
AS  
BEGIN  

--VARIABLES
DECLARE @L_TC_Descripcion				VARCHAR(255)    = @Descripcion,		@L_TF_Inicio_Vigencia			DATETIME2(3)	= @InicioVigencia,		@L_TF_Fin_Vigencia				DATETIME2(3)	= @FinVigencia
--LÓGICA
	INSERT INTO [Catalogo].[TipoItineracion] WITH(ROWLOCK)
	(
		[TC_Descripcion],	[TF_Inicio_Vigencia],	[TF_Fin_Vigencia]
	)
	VALUES
    (	
		@L_TC_Descripcion,	@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia
	)
END
GO
