SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				Stefany Quesada
-- Fecha de creación:		<18/05/2017>
-- Descripción:				<Permite eliminar los archivos de comunicación por el CodArchivoComunicacion .>
-- Modificación:            Diego Navarrete
-- descripción:             <se cambia nombre de variable>
-- ===========================================================================================

CREATE PROCEDURE [Comunicacion].[PA_EliminarArchivoComunicacion]
@CodComunicacion Uniqueidentifier
	
As
Begin

   Delete 
   From		[Comunicacion].[ArchivoComunicacion] 
   Where	TU_CodComunicacion=	@CodComunicacion

End

GO
