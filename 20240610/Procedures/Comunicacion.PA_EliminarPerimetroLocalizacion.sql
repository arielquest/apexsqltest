SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Permite eliminar registros de Comunicacion.PerimetroLocalizacion.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_EliminarPerimetroLocalizacion]
	@CodPerimetro		smallint
As
Begin
	Delete From	[Comunicacion].[PerimetroLocalizacion]
	Where		TN_CodPerimetro = @CodPerimetro;
End
GO
