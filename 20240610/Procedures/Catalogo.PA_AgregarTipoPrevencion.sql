SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<08/03/2020>
-- Descripción :			<Permite agregar un nuevo registro al catálogo de Tipo Prevencion>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoPrevencion]
	@Descripcion varchar(100),
	@InicioVigencia datetime2,
	@FinVigencia datetime2

AS  
BEGIN  
		INSERT INTO Catalogo.TipoPrevencion
		(			
			TC_Descripcion,
			TF_Inicio_Vigencia,
			TF_Fin_Vigencia
		) 
		VALUES(
			@Descripcion,
			@InicioVigencia,
			@FinVigencia
		)
END
GO
