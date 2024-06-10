SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Pablo Alvarez>
-- Fecha de creación:	<21/12/2016>
-- Descripción :		<Permite Eliminar una asociacion TipoFuncionario a un TipoOficina> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarTipoOficinaTipoFuncionario]
   @CodTipoOficina	    smallint,
   @CodTipoFuncionario	smallint 
AS
BEGIN          
	DELETE FROM Catalogo.TipoOficinaTipoFuncionario
	WHERE	TN_CodTipoOficina = @CodTipoOficina 
	AND		TN_CodTipoFuncionario = @CodTipoFuncionario
END
 

GO
