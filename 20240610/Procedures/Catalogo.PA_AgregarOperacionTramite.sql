SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================
-- Autor:				<Isaac Dobles Mata.>
-- Fecha Creación:		<04/04/2022>
-- Descripcion:			<Crear nueva operación para trámites encadenamiento>
-- =========================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarOperacionTramite] 
	@Nombre					VARCHAR(100),
	@Descripcion			VARCHAR(255),
	@FechaActivacion		DateTime2(7),
	@FechaVencimiento		DateTime2(7),
	@Pantalla				TinyInt
AS
BEGIN

	--Variables locales
	DECLARE @L_Nombre					VARCHAR(100)	= @Nombre,
			@L_Descripcion				VARCHAR(255)	= @Descripcion,
			@L_FechaActivacion			DateTime2(7)	= @FechaActivacion,
			@L_FechaVencimiento			DateTime2(7)	= @FechaVencimiento,
	        @L_Pantalla					TinyInt			= @Pantalla


	--Aplicación de inserción
	INSERT INTO Catalogo.OperacionTramite
	(
		[TC_Nombre],					
		[TC_Descripcion],	
		[TF_Inicio_Vigencia],	
		[TF_Fin_Vigencia],
		[TN_Pantalla]
	)
	VALUES
	(
		@L_Nombre,		
		@L_Descripcion,		
		@L_FechaActivacion,		
		@L_FechaVencimiento, 
		@L_Pantalla			
	)

END
GO
