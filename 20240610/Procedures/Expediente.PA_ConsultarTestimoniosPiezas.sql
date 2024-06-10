SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aarón Ríos Retana>
-- Fecha de creación:		<04/05/2022>
-- Descripción :			<HU 117183 - Realiza una consulta de los testimonios de piezas relacionados a un expediente
-- =========================================================================================================================================================================

CREATE     PROCEDURE [Expediente].[PA_ConsultarTestimoniosPiezas]
			@NumeroExpediente			CHAR(14),
			@CodContexto				CHAR(4)
AS
BEGIN
	DECLARE	@L_Nue						CHAR(14)	=	@NumeroExpediente,
			@L_CodContexto				CHAR(4)		=	@CodContexto

			--Obtener los testimonios de piezas relacionados a un expediente
			SELECT 
			ED.TC_NumeroExpediente											AS	Numero,
			ED.TC_TestimonioPiezas											AS  NumeroTestimonio,
			CONDET.TC_CodContexto											AS	CodigoContextoDetalle,
			CONDET.TC_Descripcion											AS	DescripcionContextoDetalle,
			'Split'															AS	Split,					
			MAT.TC_CodMateria												AS	Codigo,
			MAT.TC_Descripcion												AS	Descripcion,
			'Split'															AS	Split,	
			CON.TC_CodContexto												AS	Codigo,
			CON.TC_Descripcion												AS	Descripcion,
			'Split'															AS	Split,	
			CLA.TN_CodClase													AS	Codigo,
			CLA.TC_Descripcion												AS	Descripcion,
			'Split'															AS	Split,	
			OFI.TC_CodOficina												AS	Codigo,
			OFI.TC_Nombre													AS	Descripcion
			FROM
						Expediente.ExpedienteDetalle						AS	ED	WITH	(NOLOCK)
			INNER JOIN	
						Expediente.Expediente								AS	E	WITH	(NOLOCK) 
			ON			ED.TC_NumeroExpediente	=	E.TC_NumeroExpediente
			INNER JOIN	CATALOGO.Contexto									AS	CON	WITH	(NOLOCK)
			ON			CON.TC_CodContexto		=		E.TC_CodContexto
			INNER JOIN	CATALOGO.Contexto									AS	CONDET	WITH	(NOLOCK)
			ON			CONDET.TC_CodContexto	=		ED.TC_CodContexto
			INNER JOIN	CATALOGO.Materia									AS	MAT	WITH	(NOLOCK)
			ON			MAT.TC_CodMateria		=		CON.TC_CodMateria
			INNER JOIN	CATALOGO.Clase										AS	CLA	WITH	(NOLOCK)
			ON			CLA.TN_CodClase			=		ED.TN_CodClase
			INNER JOIN	CATALOGO.Oficina									AS	OFI	WITH	(NOLOCK)
			ON			OFI.TC_CodOficina		=		CON.TC_CodOficina
			WHERE 
						ED.TC_TestimonioPiezas	=		@L_Nue
			AND			ED.TC_CodContexto		=		@L_CodContexto
END
GO
