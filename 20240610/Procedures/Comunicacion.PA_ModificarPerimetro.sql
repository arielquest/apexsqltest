SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/12/2016>
-- Descripción :			<Permite modifcar un registro de Comunicacion.Perimetro.>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ModificarPerimetro]
	@CodPerimetro			smallint,
	@Descripcion			varchar(100),
	@CodOficinaOCJ			varchar(4),
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
As
Begin
	Update [Comunicacion].[Perimetro]
	   Set [TC_Descripcion]			= @Descripcion
		  ,[TC_CodOficinaOCJ]		= @CodOficinaOCJ
		  ,[TF_Inicio_Vigencia]		= @FechaActivacion
		  ,[TF_Fin_Vigencia]		= @FechaDesactivacion
	 Where TN_CodPerimetro			= @CodPerimetro;
End
GO
