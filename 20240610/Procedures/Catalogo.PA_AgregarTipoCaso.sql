SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<25/01/2019>
-- Descripción :			<Permite Agregar un nuevo tipo de caso en la tabla Catalogo.TipoCaso> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoCaso]
	@Descripcion		varchar(255),
	@FechaActivacion	datetime2,
	@FechaDesactivacion datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.TipoCaso
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@FechaActivacion,		@FechaDesactivacion
	)
End


GO
