SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite agregar una nueva escolaridad a a la tabla Catalogo.Escolaridad> 

-- Modificado por:			<Olger Gamboa castillo>
-- Fecha de creación:		<14/12/2015>
-- Descripción :			<se modifica para que el código sea autogenerado> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEscolaridad]
	@Descripcion varchar(150),
	@InicioVigencia datetime2(7),
	@FinVigencia datetime2(7)
	

AS  
BEGIN  

	Insert Into		Catalogo.Escolaridad
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End






GO
