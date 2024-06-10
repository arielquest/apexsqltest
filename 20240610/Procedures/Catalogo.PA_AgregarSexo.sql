SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<19/08/2015>
-- Descripción :			<Permite Agregar un nuevo Sexo en la tabla Catalogo.Sexo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarSexo]
	@CodSexo varchar(9),
	@Descripcion varchar(100),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.Sexo
	(
		TC_CodSexo,		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@CodSexo,		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End



GO
