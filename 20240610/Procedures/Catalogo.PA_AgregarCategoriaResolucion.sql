SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<04/09/2018>
-- Descripción :		<Permite Agregar una nueva categoría resolución> 
-- ===================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarCategoriaResolucion]
	@Descripcion		varchar(100),
	@InicioVigencia		datetime2,
	@FinVigencia		datetime2
AS  
BEGIN
	Insert Into		Catalogo.CategoriaResolucion
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End
GO
