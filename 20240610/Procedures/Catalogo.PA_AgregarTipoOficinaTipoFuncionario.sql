SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Pablo Alvarez>
-- Fecha de creación:	<21/12/2016>
-- Descripción :		<Permite Agregar TipoFuncionarios a una TipoOficina> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoOficinaTipoFuncionario]
	@CodTipoOficina			smallint,
	@CodTipoFuncionario smallint,
	@Inicio_Vigencia	datetime2(7)
AS 
BEGIN
	INSERT INTO Catalogo.TipoOficinaTipoFuncionario
	(
		TN_CodTipoOficina,	TN_CodTipoFuncionario, TF_Inicio_Vigencia 
	)
	VALUES
	(
		@CodTipoOficina,	@CodTipoFuncionario,	@Inicio_Vigencia 
	)
END
 

GO
