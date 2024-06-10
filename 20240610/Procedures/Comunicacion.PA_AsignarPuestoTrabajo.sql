SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<21/03/2017>
-- Descripción :			<Permite actualizar el puesto de trabajo>
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Modificado por :         <Diego Navarrete>
-- Fecha :					<31/10/2017>
-- Descripción :			<Se agrega el campo [TF_Actualizacion] para actualizarlo>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AsignarPuestoTrabajo]
	@CodPuestoTrabajo				varchar(14),
	@CodComunicacion                uniqueidentifier
	
As
Begin

	Update [Comunicacion].Comunicacion 
	Set [TC_CodPuestoTrabajo]					= @CodPuestoTrabajo,
	    [TF_Actualizacion]						= GETDATE()
	Where TU_CodComunicacion		            = @CodComunicacion;
		
End


GO
