SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<20/04/2016>
-- Descripción :			<Permite agregar un criterio de busqueda.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Consulta].[PA_AgregarCriterio]
	@Nombre					varchar(50),
	@Criterio				varchar(50),
	@CodModulo				smallint,
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
AS 
BEGIN
	INSERT INTO [Consulta].[Criterio]
			   ([TC_Nombre]
			   ,[TC_Criterio]
			   ,[TN_CodModulo]
			   ,[TF_Inicio_Vigencia]
			   ,[TF_Fin_Vigencia])
		 VALUES
			   (@Nombre
			   ,@Criterio
			   ,@CodModulo
			   ,@FechaActivacion
			   ,@FechaDesactivacion);
END
GO
