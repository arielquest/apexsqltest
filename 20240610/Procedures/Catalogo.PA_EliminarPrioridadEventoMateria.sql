SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<14/11/2016>
-- Descripción :			<Permite eliminar un registro de Catalogo.PrioridadEventoMateria.>
-- ================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarPrioridadEventoMateria]
	@CodPrioridadEvento		smallint,
	@CodMateria				varchar(5)
As 
Begin
	Delete From		Catalogo.PrioridadEventoMateria
	Where			TN_CodPrioridadEvento		= @CodPrioridadEvento
	And				TC_CodMateria				= @CodMateria;
End
GO
