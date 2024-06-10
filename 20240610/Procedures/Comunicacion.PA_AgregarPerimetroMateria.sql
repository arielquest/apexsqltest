SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<30/01/2017>
-- Descripción :			<Permite agregar un registro a Comunicacion.PerimetroMateria.>
-- ================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarPerimetroMateria]
	@CodPerimetro			smallint,
	@CodMateria				varchar(5),
	@FechaAsociacion		datetime2
As 
Begin
	Insert Into Comunicacion.PerimetroMateria
		(TN_CodPerimetro, 
		TC_CodMateria, 
		TF_Inicio_Vigencia)
	Values
		(@CodPerimetro,
		@CodMateria,
		@FechaAsociacion);
End
GO
