SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<06/02/2017>
-- Descripción :			<Permite agregar un registro a Comunicacion.PuestoTrabajoSector.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarPuestoTrabajoSector]
	@CodPuestoTrabajo		varchar(14),
	@CodSector				smallint,
	@FechaActivacion		datetime2
As
Begin
	Insert Into [Comunicacion].[PuestoTrabajoSector]
			   (TC_CodPuestoTrabajo
			   ,[TN_CodSector]
			   ,[TF_Inicio_Vigencia])
		 Values
			   (@CodPuestoTrabajo
			   ,@CodSector
			   ,@FechaActivacion)
End
GO
