SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<11/10/2019>
-- Descripción:				<Modifica un registro de tipo de vehículo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoVehiculo]	
	@Codigo smallint,
	@Descripcion varchar(100),
	@Observacion varchar(255),
	@FinVigencia datetime2
AS  
BEGIN  

	Update	Catalogo.TipoVehiculo
	Set		TC_Descripcion				=	@Descripcion,
			TC_Observacion				=	@Observacion,
			TF_Fin_Vigencia				=	@FinVigencia
	Where	TN_CodTipoVehiculo			=	@Codigo
End
GO
