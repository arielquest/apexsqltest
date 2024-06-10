SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<28-03-2023>
-- Descripción :			<Permite eliminar todos los barrios de un sector>
-- ===========================================================================================
CREATE   PROCEDURE [Comunicacion].[PA_EliminarSectorBarrio]
	@CodSector		smallint
As
Begin
	Delete From	[Comunicacion].[SectorBarrio]
	Where		TN_CodSector	= @CodSector;
End
GO
