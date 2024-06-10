SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Agregar un nuevo tipo de estado en la tabla Catalogo.TipoEstado> 
-- Modificado :				<Alejandro Villalta, 14/12/2015, Se modifica el tipo de dato del codigo de tipo estado.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEstado]
	@Descripcion varchar(150),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
AS  
BEGIN  

	Insert Into		Catalogo.TipoEstado
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End


GO
