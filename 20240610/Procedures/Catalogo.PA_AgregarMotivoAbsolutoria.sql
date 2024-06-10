SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<28/08/2015>
-- Descripción :			<Permite agregar un nuevo tipo de absolutoria> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoAbsolutoria]
	@Descripcion varchar(255),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	
AS  
BEGIN  

	Insert Into		Catalogo.MotivoAbsolutoria
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End






GO
