SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<11/08/2015>
-- Descripción :			<Permite Modificar un procedimiento en la tabla Catalogo.Procedimiento> 
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodProcedimiento por estandar.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarProcedimiento]
	@CodProcedimiento	smallint,
	@Descripcion		varchar(100),	
	@FinVigencia		datetime2
AS  
BEGIN  

	Update	Catalogo.Procedimiento 
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia
	Where	TN_CodProcedimiento 			=	@CodProcedimiento
End


GO
