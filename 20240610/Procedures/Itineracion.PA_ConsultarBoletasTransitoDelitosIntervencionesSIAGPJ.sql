SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<19/01/2020>
-- Descripción :			<Permite consultar boletas de tránsito y delitos asociados a un Interviniente de un expediente/legajo de SIAGPJ mapeado a registros de Gestión 
--							 con sus catálogos respectivos>
-- =============================================================================================================================================================================
-- Modificación:			<22/01/2021><Ronny Ramírez R.> <Se modifica para hacer coincidir el cambio en el tipo de dato de Boleta de tránsito de INT a string en SIAGPJ>
-- Modificación:			<26/01/2021><Karol Jiménez Sánchez> <Se modifica para incluir consulta de delitos de Intervenciones>
-- Modificación:			<09/02/2021><Karol Jiménez Sánchez> <Se modifica para incluir consulta de CARPETA>
-- Modificación:			<11/02/2021><Karol Jiménez Sánchez> <Se modifica para incluir consulta de IDINT>
-- Modificación:			<20/02/2021><Karol Jiménez Sánchez> <Se modifica para generar IDOBJ de DCAROBJ y IDDEL de DINTDEL, con IDENTITYs>
-- Modificación:			<02/03/2021><Ronny Ramírez R.> <Se modifica para agregar un valor por defecto por configuración para CODOBJNAT>
-- Modificación:			<28/06/2021><Ronny Ramírez R.> <Se agregan los nuevos campos de INSPECTOR y FECBOLETA al mapeo, aún no se tiene el de la autoridad registrada>
-- Modificación:			<01/07/2021><Ronny Ramírez R.> <Se asocia el IDINT a DCAROBJ, pues se asociaba un 0 por defecto>
-- Modificación:			<06/03/2023><Karol Jiménez S.><Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogo Delito)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarBoletasTransitoDelitosIntervencionesSIAGPJ]
	@CodHistoricoItineracion	UNIQUEIDENTIFIER
AS 
BEGIN
	--Variables 
	DECLARE	@L_NumeroExpediente			VARCHAR(14),
			@L_CodLegajo				UNIQUEIDENTIFIER	= NULL,
			@L_Carpeta					VARCHAR(14)			= NULL,
			@L_CodContextoOrigen		VARCHAR(4)			= NULL,
			@L_ValorDefectoDelito		VARCHAR(9)			= NULL,
			@L_ValorDefectoCODOBJNAT	VARCHAR(5)			= NULL;

	Declare @Intervinientes As Table (
		TU_CodInterviniente			UNIQUEIDENTIFIER		NOT NULL,
		IDINT						BIGINT					NULL);

	Declare @DINTDEL As Table (
		CARPETA				VARCHAR(14)			NOT NULL,
		IDINT				INT					NOT NULL,
		IDDEL				INT					NOT NULL IDENTITY(1,1),
		CODDEL				VARCHAR(9)			NOT NULL,
		FECCAL				DATETIME2(3)		NOT NULL,
		CODESTDEL			VARCHAR(3)			NOT NULL,
		CODGRA				VARCHAR(3)			NULL,
		TIPACU				VARCHAR(1)			NULL, 
		CONDENA				VARCHAR(1)			NULL,
		FECCONDENA			DATETIME2(3)		NULL, 
		DELREP				VARCHAR(1)			NULL
	);

	DECLARE @DCAROBJ AS TABLE (
		NUE					VARCHAR(14)			NOT NULL,
		IDOBJ				INT					NOT NULL IDENTITY(1,1),
		IDOBJDESG			INT					NULL,
		REFER				VARCHAR(50)			NOT NULL,
		DESCRIP				VARCHAR(2048)		NOT NULL,
		CODOBJ				VARCHAR(5)			NOT NULL,
		CODOBJNAT			VARCHAR(5)			NOT NULL,
		CODESTOBJ			VARCHAR(5)			NULL,
		FECEST				DATETIME2(3)		NULL,
		IDINT				INT					NULL,
		CODDEJ				VARCHAR(4)			NOT NULL,
		BOLETANUM			VARCHAR(20)			NULL,
		FECGRAV				DATETIME2(3)		NULL,
		FECLEVGRAV			DATETIME2(3)		NULL,
		GRAVAMEN			VARCHAR(255)		NULL,
		MARCHAMO			VARCHAR(20)			NULL,
		INSPECTOR			VARCHAR(5)			NULL,
		FECBOLETA			DATETIME2(3)		NULL,
		USURESP				VARCHAR(50)			NULL,
		ARTINF				VARCHAR(255)		NULL,
		CODJUE				VARCHAR(11)			NULL,
		UBICACION			VARCHAR(255)		NULL,
		PLACAVDEC			VARCHAR(255)		NULL,
		ENTREGADOA			VARCHAR(255)		NULL);

	SELECT  @L_NumeroExpediente		= TC_NumeroExpediente,
			@L_CodLegajo			= TU_CodLegajo,
			@L_Carpeta				= CARPETA,
			@L_CodContextoOrigen	= TC_CodContextoOrigen
	FROM	Itineracion.FN_ConsultarExpLegajoHistoricoItineracion(@CodHistoricoItineracion);

	SELECT	@L_ValorDefectoDelito		= Itineracion.FN_ConsultarValorDefectoConfiguracion('C_ITIG_Delito','');
	SELECT	@L_ValorDefectoCODOBJNAT	= Itineracion.FN_ConsultarValorDefectoConfiguracion('U_ITIG_CODOBJNAT_X_Defecto','');


	INSERT INTO @Intervinientes
				(TU_CodInterviniente,			IDINT)
	SELECT		A.TU_CodInterviniente,			A.IDINT
	FROM		Expediente.Intervencion			A WITH(NOLOCK)
	Left Join	Expediente.LegajoIntervencion	B WITH(NOLOCK)
	On			B.TU_CodInterviniente			= A.TU_CodInterviniente
	And			B.TU_CodLegajo					= @L_CodLegajo
	WHERE		A.TC_NumeroExpediente			= @L_NumeroExpediente
	AND			((@L_CodLegajo IS NOT NULL AND TU_CodLegajo = @L_CodLegajo)
	OR			@L_CodLegajo IS NULL);

	INSERT INTO @DCAROBJ
				(NUE,		REFER,	DESCRIP,	CODOBJ,		
				CODOBJNAT,	IDINT,	CODDEJ, 	BOLETANUM,
				INSPECTOR,	FECBOLETA)
	SELECT		@L_NumeroExpediente						 NUE,
				ISNULL(A.TC_Placa, 'Itineración')		 REFER,
				ISNULL(A.TC_Descripcion, 'Itineración')	 DESCRIP,
				'BOL'									 CODOBJ,
				ISNULL(@L_ValorDefectoCODOBJNAT,'MEDPR') CODOBJNAT, -- El valor "Itineracion" no es válido en el catálogo KOBJNAT de Gestión
				B.IDINT									 IDINT,
				D.TC_CodContextoDestino					 CODDEJ,
				CONCAT(
				CASE 
						WHEN A.TN_SerieBoleta = 9999 THEN ''
						ELSE CONCAT(A.TN_SerieBoleta,'-') 
					END,
					A.TN_NumeroBoleta
				)										BOLETANUM, -- Si el # de serie es 9999, es un valor por defecto de mapeo a gestión, por lo que no se envía
				A.TC_CodInspector						INSPECTOR,
				A.TF_FechaBoleta						FECBOLETA
	FROM		Expediente.IntervinienteBoletaTransito	A	WITH(NOLOCK)
	INNER JOIN	@Intervinientes							B	
	ON			B.TU_CodInterviniente					=	A.TU_CodInterviniente
	INNER JOIN	Historico.Itineracion					D	WITH(NOLOCK)
	ON			D.TU_CodHistoricoItineracion			=	@CodHistoricoItineracion
	LEFT JOIN	Expediente.LegajoINTervencion			C	WITH(NOLOCK)
	ON			C.TU_CodINTerviniente					=	B.TU_CodINTerviniente

	INSERT INTO @DINTDEL 
				(CARPETA,		 IDINT,		CODDEL,		FECCAL,		CODESTDEL)
	SELECT		
				@L_Carpeta									CARPETA,
				A.IDINT										IDINT,
				ISNULL(Configuracion.FN_ObtenerEquivalenciaCatalogoSIAGPJaExterno(@L_CodContextoOrigen,'Delito', B.TN_CodDelito,0,0),@L_ValorDefectoDelito), --CODDEL
				B.TF_CalificacionDelito						FECCAL,
				'ACT'										CODESTDEL
	FROM		@Intervinientes								A
	INNER JOIN	Expediente.IntervinienteDelito				B WITH(NOLOCK)
	ON			B.TU_CodInterviniente						= A.TU_CodInterviniente
	INNER JOIN	Expediente.Intervencion						D WITH(NOLOCK)
	ON			D.TU_CodInterviniente						= A.TU_CodInterviniente

	SELECT * from @DINTDEL;
	SELECT * FROM @DCAROBJ;

END
GO
