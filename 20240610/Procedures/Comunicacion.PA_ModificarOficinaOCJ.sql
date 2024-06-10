SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===============================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Chavarria>
-- Fecha de creación:		<21/03/2017>
-- Descripción :			<Cambiar la Oficiana de cominicación>
---------------------------------------------------------------------------------------------
-- Fecha :	            	<31/10/2017>
-- Modificado por:			<Diego Navarrete>
-- Descripción :			<Se agrega el campo [TF_Actualizacion] para actualizarlo>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ModificarOficinaOCJ]
@CodigoComunicacion Uniqueidentifier,
@CodigoOficinaOCJ   Varchar(4)
AS
BEGIN
	UPDATE [Comunicacion].[Comunicacion]
	SET    [TC_CodContextoOCJ]				= @CodigoOficinaOCJ,
		   [TF_Actualizacion]				= GETDATE() 
	WHERE  [TU_CodComunicacion]				= @CodigoComunicacion
END
GO
