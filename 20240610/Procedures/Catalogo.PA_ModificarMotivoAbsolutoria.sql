SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<28/08/2015>
-- Descripción :			<Permite Modificar un motivo absolutoria> 
-- Modificado :				<Alejandro Villalta><08/01/2016><Modificar el tipo de dato del codigo de motivo absolutoria> 
-- Modificación:		    <02-12-2016><Pablo Alvarez><Se modifica TN_CodMotivoAbsolutoria por estandar.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoAbsolutoria]
	@CodMotivoAbsolutoria	smallint,
	@Descripcion		varchar(255),	
	@FinVigencia		datetime2
AS  
BEGIN  

	Update	Catalogo.MotivoAbsolutoria
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia
	Where	TN_CodMotivoAbsolutoria 			=	@CodMotivoAbsolutoria
End



GO
