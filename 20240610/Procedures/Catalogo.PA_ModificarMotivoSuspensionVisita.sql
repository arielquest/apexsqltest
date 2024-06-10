SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite Modificar un motivo de suspencion de visita carcelaria en la tabla Catalogo.MotivoSuspencionVisita> 
-- Modificacion:			14/12/2015  Modificar tipo dato CodMotivo a smallint Johan Acosta
-- Modificacion:			02/12/2015  Modificar TN_CodMotivo por estandar
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoSuspensionVisita]

	@CodMotivo smallint,
	@Descripcion varchar(200),	
	@FinVigencia datetime2	
	

AS  
BEGIN  

	Update	Catalogo.MotivoSuspensionVisita
	Set		TC_Descripcion		=	@Descripcion,		
			TF_Fin_Vigencia		=	@FinVigencia				
	Where	TN_CodMotivo		=	@CodMotivo
End


GO
