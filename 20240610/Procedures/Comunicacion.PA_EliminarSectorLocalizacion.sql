SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/01/2017>
-- Descripción :			<Permite eliminar registros de Comunicacion.SectorLocalizacion.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_EliminarSectorLocalizacion]
	@CodSector		smallint
As
Begin
	Delete From	[Comunicacion].[SectorLocalizacion]
	Where		TN_CodSector	= @CodSector;
End

GO
