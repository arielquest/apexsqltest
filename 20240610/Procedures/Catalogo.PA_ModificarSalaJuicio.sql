SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/12/2016>
-- Descripción :			<Permite modifcar un registro de Catalogo.SalaJuicio.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarSalaJuicio]
	@CodSalaJuicio			smallint,
	@CodCircuito			smallint,
	@Descripcion			varchar(255),
	@Observaciones			varchar(200),
	@Capacidad				smallint,
	@Habilitada				bit,
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
As
Begin
	Update [Catalogo].[SalaJuicio]
	   Set [TN_CodCircuito]			= @CodCircuito
		  ,[TC_Descripcion]			= @Descripcion
		  ,[TC_Observaciones]		= @Observaciones
		  ,[TN_Capacidad]			= @Capacidad
		  ,[TB_Habilitada]			= @Habilitada
		  ,[TF_Inicio_Vigencia]		= @FechaActivacion
		  ,[TF_Fin_Vigencia]		= @FechaDesactivacion
	 WHERE [TN_CodSala]				= @CodSalaJuicio;
End
GO
