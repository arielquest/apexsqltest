SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<07/11/2016>
-- Descripción :			<Permite agregar un registro a Catalogo.PrioridadEvento.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarPrioridadEvento]
	@Descripcion			varchar(150),
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
As  
Begin  
	Insert Into [Catalogo].[PrioridadEvento]
			   ([TC_Descripcion]
			   ,[TF_Inicio_Vigencia]
			   ,[TF_Fin_Vigencia])
		 Values
			   (@Descripcion
			   ,@FechaActivacion
			   ,@FechaDesactivacion);
End
GO
