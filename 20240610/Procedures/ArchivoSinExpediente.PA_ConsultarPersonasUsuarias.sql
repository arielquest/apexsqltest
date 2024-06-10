SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<06/11/2018>
-- Descripción :			<Permite consultar las personas usuarias asignadas dentro de un documento sin expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [ArchivoSinExpediente].[PA_ConsultarPersonasUsuarias]
	@CodArchivo				uniqueidentifier
AS  
BEGIN  

	SELECT		
	A.[TC_Identificacion]			AS	Identificacion,
	A.[TC_Nombre]					AS	Nombre,
	A.[TC_PrimerApellido]			AS	PrimerApellido,
	A.[TC_SegundoApellido]			AS	SegundoApellido,
	A.[TC_DescripcionFirma]			AS 	DescripcionFirma,
	A.[TF_Firma]					AS	FechaFirma,
	'SplitTipoIdentificacion'   	AS  SplitTipoIdentificacion,
	A.[TN_CodTipoIdentificacion]	AS	Codigo,
	B.[TC_Descripcion] 				AS	Descripcion,
	'SplitTipoFirma'				AS	SplitTipoFirma,
    A.[TC_TipoFirma]				AS	TipoFirma
		
	FROM							[ArchivoSinExpediente].[PersonaUsuaria] 		AS A With(Nolock)		
	INNER JOIN						[Catalogo].[TipoIdentificacion]					AS B With(Nolock) 	
	ON								A.TN_CodTipoIdentificacion 						= B.TN_CodTipoIdentificacion 
	WHERE	    					A.[TU_CodArchivo]							    = @CodArchivo	
END
GO
