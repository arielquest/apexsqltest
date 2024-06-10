SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<10/10/2019>
-- Descripción :			<Permite agregar un nuevo registro al catálogo de Tipo Vehículo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoVehiculo]
	@Descripcion varchar(100),
	@Observacion varchar(255),
	@InicioVigencia datetime2,
	@FinVigencia datetime2

AS  
BEGIN  
		INSERT INTO Catalogo.TipoVehiculo
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
