SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<06/02/2017>
-- Descripción :			<Permite eliminar un registro de Comunicacion.PuestoTrabajoSector.>
-- ================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_EliminarPuestoTrabajoSector]
	@CodPuestoTrabajo		varchar(14),
    @CodSector		smallint
As 
Begin
	Delete From		Comunicacion.PuestoTrabajoSector
	Where			TC_CodPuestoTrabajo		    = @CodPuestoTrabajo 
	And				TN_CodSector				= @CodSector
End
GO
