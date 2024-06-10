SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/12/2016>
-- Descripción :			<Permite agregar un registro a Comunicacion.Perimetro.>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarPerimetro]
	@Descripcion			varchar(100),
	@CodOficinaOCJ			varchar(4),
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2,
	@CodPerimetro			smallint		output
As
Begin
	Declare @Insertado table (Codigo int);

	Insert Into [Comunicacion].[Perimetro]
			   ([TC_Descripcion]
			   ,[TC_CodOficinaOCJ]
			   ,[TF_Inicio_Vigencia]
			   ,[TF_Fin_Vigencia])
	     Output Inserted.TN_CodPerimetro Into @Insertado
		 Values
			   (@Descripcion
			   ,@CodOficinaOCJ
			   ,@FechaActivacion
			   ,@FechaDesactivacion);

	Select @CodPerimetro = Codigo From @Insertado;
End
GO
