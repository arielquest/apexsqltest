SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<15/10/2019>
-- Descripción:				<Modifica un registro de estilo de vehículo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEstiloVehiculo]	
	@Codigo smallint,
	@Descripcion varchar(100),
	@Observacion varchar(255),
	@FinVigencia datetime2
AS  
BEGIN  

	Update	Catalogo.EstiloVehiculo
	Set		TC_Descripcion				=	@Descripcion,
			TC_Observacion				=	@Observacion,
			TF_Fin_Vigencia				=	@FinVigencia
	Where	TN_CodEstiloVehiculo			=	@Codigo
End
GO
