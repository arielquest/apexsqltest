SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Permite eliminar(desactivar) un domicilio de una persona> 
-- =================================================================================================================================================
-- Modificacion:			<01/11/2019> <Isaac Dobles Mata> Se cambia TB_Activo por TB_Domicilio habitual
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_EliminarDomicilio] 
	@CodDomicilio				uniqueidentifier	
AS
BEGIN

	Update	Persona.Domicilio
	Set		TB_DomicilioHabitual	=0
	Where	TU_CodDomicilio				=	@CodDomicilio
END
GO
