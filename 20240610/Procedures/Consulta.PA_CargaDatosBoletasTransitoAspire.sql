SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida Elena Siles R>
-- Fecha de creación:		<09/03/2022>
-- Descripción :			<Realiza una consulta de todas las boletas de tránsito registradas en la base de datos de SIAGPJ para ser utilizada por los componentes Aspire y ElasticSearch> 
-- Modificación:			<Gabriel Arnaez H.> <Se modifica SP para realizar cargas por lotes>
-- =========================================================================================================================================================================
CREATE   PROCEDURE [Consulta].[PA_CargaDatosBoletasTransitoAspire]
AS
	BEGIN
	
	DECLARE @ExpedientesLegajos AS TABLE
	(
		identificador					VARCHAR(150)			NOT NULL,
		codboletatransito				UNIQUEIDENTIFIER		NOT NULL,
		numeroexpediente				VARCHAR (14)			NOT NULL,
		codigolegajo					UNIQUEIDENTIFIER		NULL,
		codtipopersona					CHAR(1)					NULL,
		nombre							VARCHAR(255)			NULL,
		apellido1						VARCHAR(50)				NULL,	
		apellido2						VARCHAR(50)				NULL,
		placa							VARCHAR(20)				NULL,
		fechaboleta						DATETIME2(7)			NULL,
		serieboleta						SMALLINT				NULL,
		numeroboleta					VARCHAR(25)				NULL,
		descripcionboleta				VARCHAR(255)			NULL,
		codinspector					VARCHAR(4)				NULL,
		nombreinspector					VARCHAR(82)				NULL,
		codmarcavehiculo				SMALLINT				NULL,
		codcontexto						VARCHAR(4)				NULL,
		contextodescrip					VARCHAR(255)			NULL,
		codcontextodetalle				VARCHAR(4)				NULL,
		sa_nombre						VARCHAR(255)			NULL,
		sa_apellido1					VARCHAR(50)				NULL,
		sa_apellido2					VARCHAR(50)				NULL
	);

	DECLARE @LoteBoletasCargadas AS TABLE
	(
		identificador					VARCHAR(150)			NOT NULL,
		codboletatransito				UNIQUEIDENTIFIER		NOT NULL,
		numeroexpediente				VARCHAR (14)			NOT NULL,
		codigolegajo					UNIQUEIDENTIFIER		NULL,
		codtipopersona					CHAR(1)					NULL,
		nombre							VARCHAR(255)			NULL,
		apellido1						VARCHAR(50)				NULL,	
		apellido2						VARCHAR(50)				NULL,
		placa							VARCHAR(20)				NULL,
		fechaboleta						DATETIME2(7)			NULL,
		serieboleta						SMALLINT				NULL,
		numeroboleta					VARCHAR(25)				NULL,
		descripcionboleta				VARCHAR(255)			NULL,
		codinspector					VARCHAR(4)				NULL,
		nombreinspector					VARCHAR(82)				NULL,
		codmarcavehiculo				SMALLINT				NULL,
		codcontexto						VARCHAR(4)				NULL,
		contextodescrip					VARCHAR(255)			NULL,
		codcontextodetalle				VARCHAR(4)				NULL,
		sa_nombre						VARCHAR(255)			NULL,
		sa_apellido1					VARCHAR(50)				NULL,
		sa_apellido2					VARCHAR(50)				NULL
	);



	-- Se consulta la configuración que posee el tamaño del lote de carga

	DECLARE @TN_LoteCarga INT = CAST(ISNULL((SELECT TC_Valor FROM Configuracion.ConfiguracionValor WHERE TC_CodConfiguracion = 'U_TamanioLoteCarga_Aspire'), '100') AS INT)



		INSERT INTO @ExpedientesLegajos
		--EXPEDIENTES
		SELECT		CAST(A.TU_CodBoletaTransito AS VARCHAR(50)) + '-' + D.TC_CodContexto	identificador,
					A.TU_CodBoletaTransito													codboletatransito,
					C.TC_NumeroExpediente													numeroexpediente,		
					NULL																	codigolegajo,
					E.TC_CodTipoPersona														codtipopersona,
					IIF(E.TC_CodTipoPersona = 'F', F.TC_Nombre, G.TC_Nombre)				nombre,
					F.TC_PrimerApellido														apellido1,
					F.TC_SegundoApellido													apellido2,
					A.TC_Placa																placa,					
					A.TF_FechaBoleta														fechaboleta,
					A.TN_SerieBoleta														serieboleta,
					A.TN_NumeroBoleta														numeroboleta,
					A.TC_Descripcion														descripcionboleta,
					A.TC_CodInspector														codinspector,
					A.TC_NombreInspector													nombreinspector,
					A.TN_CodMarcaVehiculo													codmarcavehiculo,
					C.TC_CodContexto														codcontexto,
					H.TC_Descripcion														contextodescrip,
					D.TC_CodContexto														codcontextodetalle,
					IIF(E.TC_CodTipoPersona = 'F', F.TC_Nombre, G.TC_Nombre)
					COLLATE SQL_Latin1_General_Cp1251_CS_AS									sa_nombre,
					F.TC_PrimerApellido  COLLATE SQL_Latin1_General_Cp1251_CS_AS			sa_apellido1,
					F.TC_SegundoApellido COLLATE SQL_Latin1_General_Cp1251_CS_AS			sa_apellido2


		FROM		Expediente.IntervinienteBoletaTransito							A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion											B WITH(NOLOCK)
		ON			B.TU_CodInterviniente											= A.TU_CodInterviniente
		INNER JOIN	Expediente.Expediente											C WITH(NOLOCK)
		ON			C.TC_NumeroExpediente											= B.TC_NumeroExpediente
		INNER JOIN	Expediente.ExpedienteDetalle									D WITH(NOLOCK)
		ON			D.TC_NumeroExpediente											= C.TC_NumeroExpediente			
		INNER JOIN	Persona.Persona													E WITH(NOLOCK)
		ON			E.TU_CodPersona													= B.TU_CodPersona
		LEFT JOIN	Persona.PersonaFisica											F WITH(NOLOCK)
		ON			F.TU_CodPersona													= B.TU_CodPersona
		LEFT JOIN   Persona.PersonaJuridica											G WITH(NOLOCK)
		ON			G.TU_CodPersona													= B.TU_CodPersona
		INNER JOIN  Catalogo.Contexto												H WITH(NOLOCK)
		ON			H.TC_CodContexto												= C.TC_CodContexto
		WHERE		B.TU_CodInterviniente											NOT IN (SELECT	I.TU_CodInterviniente
																							FROM	Expediente.LegajoIntervencion I WITH(NOLOCK)
																							WHERE	B.TU_CodInterviniente = I.TU_CodInterviniente)
		AND			A.TB_Cargado													= 0

		UNION --LEGAJOS
		SELECT		CAST(A.TU_CodBoletaTransito AS VARCHAR(50)) + '-' +
					CAST(D.TU_CodLegajo AS VARCHAR(50)) + '-' + E.TC_CodContexto			identificador,
					A.TU_CodBoletaTransito													codboletatransito,
					D.TC_NumeroExpediente													numeroexpediente,		
					D.TU_CodLegajo															codigolegajo,
					F.TC_CodTipoPersona														codtipopersona,
					IIF(F.TC_CodTipoPersona = 'F', G.TC_Nombre, H.TC_Nombre)				nombre,
					G.TC_PrimerApellido														apellido1,
					G.TC_SegundoApellido													apellido2,
					A.TC_Placa																placa,					
					A.TF_FechaBoleta														fechaboleta,
					A.TN_SerieBoleta														serieboleta,
					A.TN_NumeroBoleta														numeroboleta,
					A.TC_Descripcion														descripcionboleta,
					A.TC_CodInspector														codinspector,
					A.TC_NombreInspector													nombreinspector,
					A.TN_CodMarcaVehiculo													codmarcavehiculo,
					D.TC_CodContexto														codcontexto,
					I.TC_Descripcion														contextodescrip,
					E.TC_CodContexto														codcontextodetalle,					 
					IIF(F.TC_CodTipoPersona = 'F', G.TC_Nombre, H.TC_Nombre)
					COLLATE SQL_Latin1_General_Cp1251_CS_AS									sa_nombre,
					G.TC_PrimerApellido  COLLATE SQL_Latin1_General_Cp1251_CS_AS			sa_apellido1,
					G.TC_SegundoApellido COLLATE SQL_Latin1_General_Cp1251_CS_AS			sa_apellido2

		FROM		Expediente.IntervinienteBoletaTransito							A WITH(NOLOCK)
		INNER JOIN	Expediente.Intervencion											B WITH(NOLOCK)
		ON			B.TU_CodInterviniente											= A.TU_CodInterviniente
		INNER JOIN  Expediente.LegajoIntervencion									C WITH(NOLOCK)
		ON			C.TU_CodInterviniente											= B.TU_CodInterviniente		
		INNER JOIN	Expediente.Legajo												D WITH(NOLOCK)
		ON			D.TC_NumeroExpediente											= B.TC_NumeroExpediente
		INNER JOIN  Expediente.LegajoDetalle										E WITH(NOLOCK)
		ON			E.TU_CodLegajo													= D.TU_CodLegajo														
		INNER JOIN	Persona.Persona													F WITH(NOLOCK)
		ON			F.TU_CodPersona													= B.TU_CodPersona
		LEFT JOIN	Persona.PersonaFisica											G WITH(NOLOCK)
		ON			G.TU_CodPersona													= B.TU_CodPersona
		LEFT JOIN   Persona.PersonaJuridica											H WITH(NOLOCK)
		ON			H.TU_CodPersona													= B.TU_CodPersona
		INNER JOIN	Catalogo.Contexto												I WITH(NOLOCK)
		ON			I.TC_CodContexto												= D.TC_CodContexto
		WHERE		A.TB_Cargado													= 0

	

		-- Se agrega el primer lote de carga
		INSERT INTO @LoteBoletasCargadas
		SELECT
		top(@TN_LoteCarga)
			identificador		
			,codboletatransito	
			,numeroexpediente	
			,codigolegajo		
			,codtipopersona		
			,nombre				
			,apellido1				
			,apellido2			
			,placa				
			,fechaboleta		
			,serieboleta		
			,numeroboleta		
			,descripcionboleta	
			,codinspector		
			,nombreinspector	
			,codmarcavehiculo	
			,codcontexto		
			,contextodescrip	
			,codcontextodetalle	
			,sa_nombre			
			,sa_apellido1		
			,sa_apellido2		
		FROM @ExpedientesLegajos

		Update Expediente.IntervinienteBoletaTransito
		SET TB_Cargado = 1
		WHERE TU_CodBoletaTransito in (select codboletatransito from @LoteBoletasCargadas)


		SELECT 
			identificador		
			,codboletatransito	
			,numeroexpediente	
			,codigolegajo		
			,codtipopersona		
			,nombre				
			,apellido1				
			,apellido2			
			,placa				
			,fechaboleta		
			,serieboleta		
			,numeroboleta		
			,descripcionboleta	
			,codinspector		
			,nombreinspector	
			,codmarcavehiculo	
			,codcontexto		
			,contextodescrip	
			,codcontextodetalle	
			,sa_nombre			
			,sa_apellido1		
			,sa_apellido2		
		FROM @LoteBoletasCargadas



	END
GO
