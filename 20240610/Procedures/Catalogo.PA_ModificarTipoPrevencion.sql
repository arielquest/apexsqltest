SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<LUis Alonso Leiva Tames>
-- Fecha de creación:		<08/03/2021>
-- Descripción:				<Modifica un registro de Tipo Prevencion>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoPrevencion]	
	@Codigo smallint,
	@Descripcion varchar(100),
	@FinVigencia datetime2
AS  
BEGIN  

	Update	Catalogo.TipoPrevencion
	Set		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FinVigencia
	Where	TN_CodTipoPrevencion		=	@Codigo
End
GO
