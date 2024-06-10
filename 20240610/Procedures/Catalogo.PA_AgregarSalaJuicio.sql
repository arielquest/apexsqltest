SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<03/11/2016>
-- Descripción :			<Permite agregar un registro a Catalogo.SalaJuicio.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarSalaJuicio]
	@CodCircuito			smallint,
	@Descripcion			varchar(255),
	@Observaciones			varchar(200),
	@Capacidad				smallint,
	@Habilitada				bit,
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
As  
Begin  
	Insert Into [Catalogo].[SalaJuicio]
			   ([TN_CodCircuito]
			   ,[TC_Descripcion]
			   ,[TC_Observaciones]
			   ,[TN_Capacidad]
			   ,[TB_Habilitada]
			   ,[TF_Inicio_Vigencia]
			   ,[TF_Fin_Vigencia])
		 Values
			   (@CodCircuito
			   ,@Descripcion
			   ,@Observaciones
			   ,@Capacidad
			   ,@Habilitada
			   ,@FechaActivacion
			   ,@FechaDesactivacion);
End
GO
