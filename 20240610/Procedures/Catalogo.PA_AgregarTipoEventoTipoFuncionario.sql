SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Permite agregar un registro a Catalogo.TipoEventoTipoFuncionario.>
-- ================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEventoTipoFuncionario]
	@CodTipoEvento		smallint,
	@CodTipoFuncionario	smallint,
	@FechaActivacion	datetime2
As 
Begin
	Insert Into Catalogo.TipoEventoTipoFuncionario
		(TN_CodTipoEvento, 
		TN_CodTipoFuncionario, 
		TF_Inicio_Vigencia)
	Values
		(@CodTipoEvento,
		@CodTipoFuncionario,
		@FechaActivacion);
End
GO
