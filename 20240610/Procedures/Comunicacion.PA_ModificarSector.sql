SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/01/2017>
-- Descripción :			<Permite modifcar un registro de Comunicacion.Sector.>
-- Modificdo:               <Cristian Cerdas Camacho><20/07/2021><Se agrega el parametro de entrada UtilizaAppMovil y se modifica el update>
--                          <Cristian Cerdas Camacho><10/08/2021><Se modifica el parámetro de entrada @UtilizaAppMovil para que reciba NULL>
-- =================================================================================================================================================
CREATE   PROCEDURE [Comunicacion].[PA_ModificarSector]
	@CodSector				smallint,
	@Descripcion			varchar(100),
	@CodOficinaOCJ			varchar(4),
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2,
	@UtilizaAppMovil		bit  = NULL
As
Begin

Declare @TempUtilizaAppMovil bit;

	IF (@UtilizaAppMovil IS NOT NULL)
		BEGIN
			SET @TempUtilizaAppMovil = @UtilizaAppMovil
		END
	ELSE
		BEGIN
			SET @TempUtilizaAppMovil = 0
		END

	Update [Comunicacion].[Sector]
	   Set [TC_Descripcion]			= @Descripcion
		  ,[TC_CodOficinaOCJ]		= @CodOficinaOCJ
		  ,[TF_Inicio_Vigencia]		= @FechaActivacion
		  ,[TF_Fin_Vigencia]		= @FechaDesactivacion
		  ,[TB_UtilizaAppMovil]		= @TempUtilizaAppMovil
	 Where TN_CodSector				= @CodSector;
End
GO
