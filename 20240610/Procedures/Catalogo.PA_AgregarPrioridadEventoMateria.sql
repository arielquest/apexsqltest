SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<14/11/2016>
-- Descripción :			<Permite agregar un registro a Catalogo.PrioridadEventoMateria.>
-- ================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarPrioridadEventoMateria]
	@CodPrioridadEvento		smallint,
	@CodMateria				varchar(5),
	@FechaAsociacion		datetime2
As 
Begin
	Insert Into Catalogo.PrioridadEventoMateria
		(TN_CodPrioridadEvento, 
		TC_CodMateria, 
		TF_Inicio_Vigencia)
	Values
		(@CodPrioridadEvento,
		@CodMateria,
		@FechaAsociacion);
End
GO
