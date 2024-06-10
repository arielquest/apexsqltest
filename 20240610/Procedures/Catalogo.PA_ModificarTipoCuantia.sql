SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Roger Lara Hernandez>
-- Fecha de creación:	<11/08/2015>
-- Descripción :		<Permite Modificar una Prioridad en la tabla Catalogo.TipoCuantia>
-- Modificado por:		<Sigifredo Leitón Luna.>
-- Fecha:				<13/01/2016>
-- Descripción:			<Se realiza cambio para autogenerar el consecutivo de tipo de cuantía - item 5630.> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoCuantia]
	@CodTipoCuantia	tinyint,
	@Descripcion	varchar(255),	
	@InicioVigencia datetime2,
	@FinVigencia	datetime2
AS  
BEGIN  
	Update	Catalogo.TipoCuantia
	Set		TC_Descripcion		=	@Descripcion,		
			TF_Fin_Vigencia		=	@FinVigencia,
			TF_Inicio_Vigencia	=	@InicioVigencia
	Where	TN_CodTipoCuantia 	=	@CodTipoCuantia
END

GO
