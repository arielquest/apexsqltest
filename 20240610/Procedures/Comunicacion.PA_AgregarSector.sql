SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/01/2017>
-- Descripción :			<Permite agregar un registro a Comunicacion.Sector.>
-- Modificdo:               <Cristian Cerdas Camacho><20/07/2021><Se agrega el parametro de entrada UtilizaAppMovil y se agrega en el Insert>
--							<Cristian Cerdas Camacho><10/08/2021><Se módifica el parámetro de entrada @UtilizaAppMovil para que reciba valores null>
-- =================================================================================================================================================
CREATE   PROCEDURE [Comunicacion].[PA_AgregarSector]
	@Descripcion			varchar(100),
	@CodOficinaOCJ			varchar(4),
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2,
	@CodSector				smallint		output,
	@UtilizaAppMovil		bit  = NULL
As
Begin
	Declare @Insertado table (Codigo int);
	Declare @TempUtilizaAppMovil bit;

	IF (@UtilizaAppMovil IS NOT NULL)
		BEGIN
			SET @TempUtilizaAppMovil = @UtilizaAppMovil
		END
	ELSE
		BEGIN
			SET @TempUtilizaAppMovil = 0
		END

	Insert Into [Comunicacion].[Sector]
			   ([TC_Descripcion]
			   ,[TC_CodOficinaOCJ]
			   ,[TF_Inicio_Vigencia]
			   ,[TF_Fin_Vigencia]
			   ,[TB_UtilizaAppMovil])
	     Output Inserted.TN_CodSector Into @Insertado
		 Values
			   (@Descripcion
			   ,@CodOficinaOCJ
			   ,@FechaActivacion
			   ,@FechaDesactivacion
			   ,@TempUtilizaAppMovil);

	Select @CodSector = Codigo From @Insertado;
End
GO
