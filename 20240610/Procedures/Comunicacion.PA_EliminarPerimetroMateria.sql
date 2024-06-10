SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<30/01/2017>
-- Descripción :			<Permite eliminar un registro de Comunicacion.PerimetroMateria.>
-- ================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_EliminarPerimetroMateria]
	@CodPerimetro			smallint,
	@CodMateria				varchar(5)
As 
Begin
	Delete From		Comunicacion.PerimetroMateria
	Where			TN_CodPerimetro				= @CodPerimetro
	And				TC_CodMateria				= @CodMateria;
End
GO
