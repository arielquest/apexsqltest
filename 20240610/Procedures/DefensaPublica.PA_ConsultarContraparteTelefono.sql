SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida Elena Siles R>
-- Fecha de creación:	<18/12/2019>
-- Descripción:			<Permite consultar un registro en la tabla: ContraparteTelefono.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ConsultarContraparteTelefono]
	@CodContraparte						UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodContraparte		UNIQUEIDENTIFIER		= @CodContraparte
	--Lógica
	SELECT		A.TU_CodTelefono							AS Codigo,			
				A.TC_Numero									AS Numero,
				A.TC_CodArea								AS CodigoArea,			
				A.TC_Extension								AS Extension,
				A.TB_SMS									AS SMS,
				A.TU_CodContraparte							AS CodContraparte,
				A.TF_Actualizacion							AS Actualizacion,
				'Split'										AS Split,
				A.TN_CodTipoTelefono						AS Codigo,
				B.TC_Descripcion							AS Descripcion
	FROM		DefensaPublica.ContraparteTelefono			A WITH (NOLOCK)
	INNER JOIN	Catalogo.TipoTelefono						B WITH (NOLOCK)
	ON			A.TN_CodTipoTelefono						= B.TN_CodTipoTelefono
	WHERE		A.TU_CodContraparte  						= @L_TU_CodContraparte
END
GO
