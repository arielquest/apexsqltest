SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<12/12/2019>
-- Descripción :			<Permite agregar un nuevo Perimetro a a la tabla Catalogo.Perimetro> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarPerimetro]
	@Descripcion varchar(100),
	@CodOfiOCJ varchar(4),
	@InicioVigencia datetime2(7),
	@FinVigencia datetime2(7)

AS  
BEGIN  
	Insert Into		Catalogo.Perimetro
	(
		TC_Descripcion,TC_CodOficinaOCJ,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion, @CodOfiOCJ,		@InicioVigencia,		@FinVigencia
	)
End






GO
