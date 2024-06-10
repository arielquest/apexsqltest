SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<17/11/2015>
-- Descripción :			<Permite Agregar un nuevo canton en la tabla Catalogo.Canton> 
-- Modificado :				<Alejandro Villalta> <16/12/2015> <Autogenerar el codigo de canton.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarCanton]
	@CodProvincia	smallint,
	@Descripcion	varchar(150),
	@InicioVigencia datetime2,
	@FinVigencia	datetime2	
AS  
BEGIN  

	Insert Into		Catalogo.Canton
	(
		TN_CodProvincia,	TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@CodProvincia,		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End



GO
