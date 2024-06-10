SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<14/10/2019>
-- Descripción :			<Permite agregar un nuevo registro al catálogo de Marca Vehículo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMarcaVehiculo]
	@Descripcion varchar(100),
	@Observacion varchar(255),
	@InicioVigencia datetime2,
	@FinVigencia datetime2

AS  
BEGIN  
		INSERT INTO Catalogo.MarcaVehiculo
		(			
			TC_Descripcion,
			TC_Observacion,
			TF_Inicio_Vigencia,
			TF_Fin_Vigencia
		) 
		VALUES(
			@Descripcion,
			@Observacion,
			@InicioVigencia,
			@FinVigencia
		)
END
GO
