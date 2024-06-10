SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<12/09/2017>
-- Descripción:				<Elimina las firmas asociadas a un de comunicación la cual se entregó a un medio físico y donde las firmas ya fueron utilizadas para generar un acta, ya que por cuestiones de seguridad no deben quedar almacenadas> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_EliminarFirmasActaComunicacion]
(
	@CodigoComunicacion uniqueidentifier
)
AS
BEGIN

	Update	Comunicacion.IntentoComunicacion
	Set		TI_FirmaDestinatario				=  Null	
	Where	TU_CodComunicacion					=	@CodigoComunicacion

END


GO
