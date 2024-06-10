SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara Hernandez>
-- Fecha de creación:		<18/11/2015>
-- Descripción :			<Permite Agregar un nuevo distrito en la tabla Catalogo.Distrito> 
--
-- Modificación:			<Andrés Díaz><15/12/2016><Se agrega el campo TG_UbicacionPunto.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarDistrito]

	@CodProvincia			smallint,
	@CodCanton				smallint,
	@Descripcion			varchar(150),
	@Latitud				float			= Null,
	@Longitud				float			= Null,
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2		= Null
AS  
BEGIN  

	Insert Into Catalogo.Distrito
	(
		TN_CodProvincia,
		TN_CodCanton,
		TC_Descripcion,
		TG_UbicacionPunto,
		TF_Inicio_Vigencia,
		TF_Fin_Vigencia
	)	
	Values
	(
		@CodProvincia,
		@CodCanton,
		@Descripcion,
		Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null),
		@FechaActivacion,
		@FechaDesactivacion
	);
End
GO
