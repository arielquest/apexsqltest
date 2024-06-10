SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<16/10/2019>
-- Descripción:				<Modifica un registro de tipo de placa>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoPlaca]	
	@Codigo smallint,
	@Descripcion varchar(100),
	@Observacion varchar(255),
	@FinVigencia datetime2
AS  
BEGIN  

	Update	Catalogo.TipoPlaca
	Set		TC_Descripcion				=	@Descripcion,
			TC_Observacion				=	@Observacion,
			TF_Fin_Vigencia				=	@FinVigencia
	Where	TN_CodTipoPlaca				=	@Codigo
End
GO
