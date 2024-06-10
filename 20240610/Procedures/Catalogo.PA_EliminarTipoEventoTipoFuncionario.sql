SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Permite eliminar un registro de Catalogo.TipoEventoTipoFuncionario.>
-- ================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoEventoTipoFuncionario]
	@CodTipoEvento		smallint,
    @CodTipoFuncionario	smallint
As 
Begin
	Delete From		Catalogo.TipoEventoTipoFuncionario
	Where			TN_CodTipoEvento		    = @CodTipoEvento 
	And				TN_CodTipoFuncionario		= @CodTipoFuncionario
End
GO
