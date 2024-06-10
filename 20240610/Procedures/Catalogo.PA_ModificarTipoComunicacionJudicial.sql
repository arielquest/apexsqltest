SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<08/12/2016>
-- Descripción :			<Permite Modificar una TipoComunicacionJudicial en la tabla Catalogo.TipoComunicacionJudicial> 

-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoComunicacionJudicial]

	@Codigo smallint,
	@Descripcion varchar(50),	
	@FinVigencia datetime2(7)	
	

AS  
BEGIN  

	Update	Catalogo.TipoComunicacionJudicial
	Set		TC_Descripcion		=	@Descripcion,		
			TF_Fin_Vigencia		=	@FinVigencia				
	Where	TN_CodTipoComunicacion	=	@Codigo
End









GO
