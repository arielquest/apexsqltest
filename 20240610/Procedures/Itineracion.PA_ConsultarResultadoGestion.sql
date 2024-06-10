SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<23/07/2021>
-- Descripción :			<Permite consultar el resultado de un de recurso de una itineración de Gestión>
-- =============================================================================================================================================================================
--Se modifica a solicitud de Paulo, el sp ya existe en la BD druizh
-- Modificación:			<02/03/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo ResultadoResolucion)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarResultadoGestion]
	@CodItineracion			Uniqueidentifier
AS
BEGIN
	--Variables 

	DECLARE @L_CodItineracion					Uniqueidentifier	= @CodItineracion,	
			@L_XML								XML,
			@L_NumeroExpediente					VARCHAR(14),
			@L_CodContextoDestino				VARCHAR(14),
			@L_ValorDefectoResultadoLegajo		VARCHAR(20)			= 'Itinerado',
			@L_CodResultadoLegajoItineracion	SMALLINT
			
	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET	@L_XML = (
					SELECT  VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS	WITH(NOLOCK) 
					WHERE	ID									= 	@CodItineracion
				);	

	SET @L_CodContextoDestino = (	SELECT	RECIPIENTADDRESS
									FROM	ItineracionesSIAGPJ.dbo.MESSAGES	WITH(NOLOCK) 
									WHERE	ID									= @CodItineracion)			

	-- Se obtiene el # de expediente del XML
	SET @L_NumeroExpediente = @L_XML.value('(/*/DCAR/NUE)[1]','VARCHAR(14)');
	
	-- Consulta de resultado recurso con equivalencias de  de cat logos de SIAGPJ
	SELECT NEWID()																											AS Codigo,
				D.E.value('(CODRESUL)[1]',	'VARCHAR(35)')																	AS CodigoResultado,
				C.TC_Descripcion																							AS Decripcion,
				F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + F.TC_SegundoApellido + ' (' + F.TC_UsuarioRed + ')'			AS UsuarioRed
	FROM		@L_XML.nodes('(/*/DCARTD6)')				X(Y)
	LEFT JOIN	@L_XML.nodes('(/*/DACO)')					A(B)
	ON			X.Y.value('(IDACORES)[1]','INT')			=	A.B.value('(IDACO)[1]', 'INT')
	INNER JOIN	Expediente.RecursoExpediente				R	WITH(NOLOCK)
	ON			R.IDACO										=	X.Y.value('(IDACOREC)[1]', 'INT')
	AND			R.TC_NumeroExpediente						=	@L_NumeroExpediente
	LEFT JOIN	Catalogo.Funcionario						F	WITH(NOLOCK)
	ON			F.TC_UsuarioRed								=	A.B.value('(IDUSU)[1]',	'VARCHAR(25)')
	INNER JOIN	@L_XML.nodes('(/*/DACORES)')				D(E)
	ON			D.E.value('(IDACOSENDOC)[1]','INT')			=	A.B.value('(IDACO)[1]', 'INT')
	LEFT JOIN	Catalogo.ResultadoResolucion				C	WITH(NOLOCK)
	ON			C.TN_CodResultadoResolucion					=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_CodContextoDestino,'ResultadoResolucion', D.E.value('(CODRESUL)[1]','VARCHAR(35)'),0,0))
		
END
GO
