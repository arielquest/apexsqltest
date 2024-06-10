SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<06/09/2019>
-- Descripción:				<Modifica un registro de tipo de itineración>
-- =================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <21/09/2020> <Se modifica el nombre de los campos fecha para que cumplan con el estándar.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoItineracion]	
	@CodTipoItineracion SMALLINT,
	@Descripcion		VARCHAR(255),	
	@FinVigencia		DATETIME2		
AS  
BEGIN  
--VARIABLES	DECLARE	@L_TN_CodTipoItineracion	SMALLINT		= @CodTipoItineracion,			@L_TC_Descripcion			VARCHAR(255)	= @Descripcion,			@L_TF_Fin_Vigencia			DATETIME2		= @FinVigencia
--LÓGICA
	UPDATE	Catalogo.TipoItineracion	WITH(ROWLOCK)
	SET		TC_Descripcion				=	@Descripcion,		
			TF_Fin_Vigencia				=	@FinVigencia				
	WHERE	TN_CodTipoItineracion		=	@CodTipoItineracion
End

GO
