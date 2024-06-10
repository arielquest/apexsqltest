SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<07/11/2016>
-- Descripción :			<Permite modifcar un registro de Catalogo.PrioridadEvento.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarPrioridadEvento]
	@CodPrioridadEvento		smallint,
	@Descripcion			varchar(150),
	@FechaDesactivacion		datetime2
As  
Begin
	Update [Catalogo].[PrioridadEvento]
	   Set [TC_Descripcion]			= @Descripcion
		  ,[TF_Fin_Vigencia]		= @FechaDesactivacion
	 Where [TN_CodPrioridadEvento]	= @CodPrioridadEvento;
End
GO
