SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================        
-- Versión:			<1.0>        
-- Creado por:		<Mike Arroyo Valenzuela>        
-- Fecha creación:  <16/08/2023>        
-- Descripción :    <Permite Consultar un Documento Firmado mediante el Código de Barras para Validación de Documentos en GL>         
-- ==================================================================================================================================================================================        
CREATE        PROCEDURE [Expediente].[PA_ConsultarDocumentoFirmado]             
	@CodContexto			VARCHAR(4),        
	@CodBarras				NVARCHAR(50)
AS        
BEGIN        
       
	DECLARE		     
				@L_TC_CodContexto				VARCHAR(4)		= @CodContexto,        
				@L_TC_CodBarras					NVARCHAR(50)	= @CodBarras  

	SELECT		AF.TF_FechaAplicado				AS				FechaAplicado,
				IA.TC_NumeroExpediente			AS				Numero,
				IA.TC_CodContextoCrea			AS				Codigo,
				F.TU_CodArchivo					AS				CodigoArchivo,
				IA.TC_Descripcion				AS				Descripcion			
	FROM		Archivo.AsignacionFirmante		AF				WITH(NOLOCK)
	INNER JOIN	Archivo.AsignacionFirmado		F				WITH(NOLOCK)
	ON			F.TU_CodAsignacionFirmado		=				AF.TU_CodAsignacionFirmado
	AND			F.TC_Estado						=				'F'
	OUTER APPLY(
		SELECT TOP 1	
				A.TC_Descripcion,
				A.TC_CodContextoCrea,
				AE.TC_NumeroExpediente
		FROM	Archivo.Archivo					A				WITH(NOLOCK)
		JOIN	Expediente.ArchivoExpediente	AE				WITH(NOLOCK)
		ON		AE.TU_CodArchivo				=				A.TU_CodArchivo
		WHERE	A.TU_CodArchivo					=				F.TU_CodArchivo
		AND		AE.TU_CodArchivo				=				F.TU_CodArchivo
		AND		A.TC_CodContextoCrea			=				@L_TC_CodContexto
	) AS IA
	WHERE		AF.TC_CodBarras					=				@L_TC_CodBarras
END
GO
