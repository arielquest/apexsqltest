SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<18/12/2020>
-- Descripción :			<Permite consultar las historico de acumulaciones de un expediente asociado a una itineración de gestión> 
-- =================================================================================================================================================
-- Modificación:			<01/03/2021> <Karol Jiménez S.> <Se cambia nombre de BD de ItineracionesSIAGPJ. de SIAGPJ, a ItineracionesSIAGPJ.SIAGPJ, según acuerdo con BT>
-- Modificación:			<03/03/2021> <Isaac Dobles Mata.> <Se modifica cláusula WHERE para que convierta el código de itineración en varchar >
-- Modificación:			<21/06/2021> <Karol Jiménez S.> <Se ajusta para evitar productos cartesianos al buscar equivalencias>
-- Modificación:			<27/02/2023><Karol Jiménez S.> <Se ajustan mapeos de tablas catálogos, se cambian a utilizar módulo de equivalencias (Catálogos Clase y	Proceso)>
-- =============================================================================================================================================================================
CREATE PROCEDURE [Itineracion].[PA_ConsultarHistoricoAcumulacionItineracionGestion]
	@CodItineracion Uniqueidentifier
As
BEGIN  
		--Variables 
		DECLARE	@L_CodItineracion		Uniqueidentifier	=	@CodItineracion,
				@L_ContextoDestino		VARCHAR(4);

		SELECT		@L_ContextoDestino					= M.RECIPIENTADDRESS
		FROM		ItineracionesSIAGPJ.dbo.MESSAGES	M WITH(NOLOCK) 
		WHERE		M.ID								= @L_CodItineracion;

		SELECT			CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)					As	CodigoAcumulacion,				
						CAST('1753-1-1' AS DATETIME)							FechaInicioAcumulacion,
						CAST('1753-1-1' AS DATETIME)							FechaActualizacion,
						NULL													FechaFinAcumulacion,
						CAST('1753-1-1' AS DATETIME)							FechaMovimiento,
						'SplitClase'											SplitClase,
						C.TN_CodClase											Codigo,
						C.TC_Descripcion										Descripcion,
						'SplitProceso'											SplitProceso,
						P.TN_CodProceso											Codigo,
						P.TC_Descripcion										Descripcion,
						'SplitContexto'											SplitContexto,
						CO.TC_CodContexto										Codigo,
						CO.TC_Descripcion										Descripcion,
						'SplitExpediente'										SplitExpediente,
						X.VALUE.value('(/*/DCAR/NUE)[1]','CHAR(14)')			Numero,
						X.VALUE.value('(/*/DCAR/DESCRIP)[1]','VARCHAR(255)')	Descripcion				
		FROM			ItineracionesSIAGPJ.dbo.MESSAGES		A 	WITH(NOLOCK)	
		INNER JOIN		ItineracionesSIAGPJ.dbo.ATTACHMENTS 	X	WITH(NOLOCK)
		ON				X.ID									=	A.ID
		LEFT JOIN		Catalogo.Clase							C	WITH(NOLOCK)
		ON				C.TN_CodClase							=	CONVERT(INT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Clase', X.VALUE.value('(/*/DCAR/CODCLAS)[1]','VARCHAR(9)'),0,0))
		LEFT JOIN		Catalogo.Proceso						P	WITH(NOLOCK) 
		ON				P.TN_CodProceso							=	CONVERT(SMALLINT, Configuracion.FN_ObtenerEquivalenciaCatalogoExternoaSIAGPJ(@L_ContextoDestino,'Proceso', X.VALUE.value('(/*/DCAR/CODPRO)[1]','VARCHAR(5)'),0,0))
		LEFT JOIN		Catalogo.Contexto						CO	WITH(NOLOCK)
		ON				CO.TC_CodContexto						=	X.VALUE.value('(/*/DCAR/CODDEJ)[1]','VARCHAR(4)')
		WHERE			A.IDACUM								=	CONVERT(varchar(36), @L_CodItineracion);
					
END
GO
