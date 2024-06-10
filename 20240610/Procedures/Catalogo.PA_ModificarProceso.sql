SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<11/08/2015>
-- Descripción :			<Permite Modificar un proceso en la tabla Catalogo.Proceso> 
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodProcedimiento por estandar.>
-- Modificación:			<05/02/2019> <Isaac Dobles Mata> <Se cambia nombre a PA_ModificarProceso y direcciona a tabla Catalogo.Proceso > 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarProceso]
	@Codigo	smallint,
	@Descripcion		varchar(100),	
	@FinVigencia		datetime2
AS  
BEGIN  

	Update	Catalogo.Proceso 
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia
	Where	TN_CodProceso 					=	@Codigo
End



GO
