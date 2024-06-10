SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===============================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<29/05/2018>
-- Descripción :			<Cambiar el contexto de comunicación>

-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ModificarContextoOCJ]
@CodigoComunicacion Uniqueidentifier,
@CodigoContextoOCJ   Varchar(4)
AS
BEGIN
	UPDATE [Comunicacion].[Comunicacion]
	SET    [TC_CodContextoOCJ]				= @CodigoContextoOCJ,
		   [TF_Actualizacion]				= GETDATE() 
	WHERE  [TU_CodComunicacion]				= @CodigoComunicacion
END
GO
