SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<07/01/2021>
-- Descripción :			<Permite consultar las boletas de tránsito asociadas a un interviniente de un expediente de Gestión con catálogos del SIAGPJ>
-- =============================================================================================================================================================================
-- Modificación:			<18/01/2021> <Ronny Ramírez R.> <Se agrega campo CODOBJ para identificar boletas de tránsito, pues hay registros con ACC y traen boleta de tránsito>
-- Modificación:			<22/01/2021> <Ronny Ramírez R.> <Se modifica para hacer coincidir el cambio en el tipo de dato de Boleta de tránsito de int a string en SIAGPJ,
--										 adicionalmente se agrega validación al mapeo del campo BOLETANUM, para detectar y asignar el # de serie cuando contenga un guión (-) >
-- Modificación:			<01/03/2021><Karol Jiménez S.> <Se cambia nombre de BD de Itineraciones de SIAGPJ, a ItineracionesSIAGPJ, según acuerdo con BT>
-- Modificación:			<08/06/2021><Luis Alonso Leiva Tames> <Se agrega la fecha, ya que es necesaria para insertar en SIAGPJ>
-- Modificación:			<29/06/2021> <Ronny Ramírez R.> <Se mapean nuevos campos de gestión y SIAGPJ>
-- =============================================================================================================================================================================
 

 CREATE PROCEDURE [Itineracion].[PA_ConsultarBoletasTransitoIntervinienteGestion]
	@CodItineracion Uniqueidentifier
AS 

BEGIN
--Variables 
DECLARE	@L_CodItineracion		Uniqueidentifier	=	@CodItineracion,
		@L_XML					XML;

	-- Se consulta el valor del campo XML para tener sus valores en memoria una sola vez
	SET @L_XML = (
					SELECT	VALUE 
					FROM	ItineracionesSIAGPJ.dbo.ATTACHMENTS WITH(NOLOCK) 
					WHERE	ID = @L_CodItineracion
				);	

	-- Common Table Expressions (CTE's) para facilitar los joins de múltiples nodos en memoria
	WITH DCAROBJ (IDINT, REFER, BOLETANUM, DESCRIP, CODOBJ, FECBOLETA, INSPECTOR, AUTO_DETENIDO, CODVEHICULODEPOSIADO, CODIGO_AUTORIDAD_REGISTRA) AS (
		SELECT	A.B.value('(IDINT)[1]', 'INT'),
				A.B.value('(REFER)[1]', 'VARCHAR(50)'),				
				A.B.value('(BOLETANUM)[1]', 'VARCHAR(20)'),
				A.B.value('(DESCRIP)[1]', 'VARCHAR(2048)'),
				A.B.value('(CODOBJ)[1]', 'VARCHAR(5)'), 
				TRY_CONVERT(DATETIME2(3),A.B.value('(FECBOLETA)[1]', 'VARCHAR(35)')),
				A.B.value('(INSPECTOR)[1]', 'VARCHAR(5)'),
				A.B.value('(AUTO_DETENIDO)[1]', 'VARCHAR(1)'),
				A.B.value('(CODVEHICULODEPOSIADO)[1]', 'VARCHAR(2)'),
				A.B.value('(CODIGO_AUTORIDAD_REGISTRA)[1]', 'VARCHAR(5)')
		FROM @L_XML.nodes('(/*/DCAROBJ)') AS A(B)
	)
	
	-- Consulta de registros de documentos con equivalencias de catálogos de SIAGPJ
	SELECT				
			CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		AS	Codigo,
			ISNULL(A.REFER, 'Itinerado')			As	Placa,
			CASE
				WHEN CHARINDEX('-', A.BOLETANUM) = 5 THEN LEFT(A.BOLETANUM, 4)
				ELSE 9999
			END										As	SerieBoleta,
			CASE
				WHEN CHARINDEX('-', A.BOLETANUM) = 5 THEN SUBSTRING(A.BOLETANUM, 6, LEN(A.BOLETANUM))
				ELSE ISNULL(A.BOLETANUM, '999999')
			END										As	NumeroBoleta,
			A.DESCRIP								As	Descripcion,
			ISNULL(A.FECBOLETA, GETDATE())			As	FechaBoleta,
			ISNULL(A.INSPECTOR, '9999')				As	CodInspector,
			ISNULL(A.INSPECTOR, '9999')				As	NombreInspector,
			CASE 
				WHEN A.AUTO_DETENIDO = '1' 
				THEN 1 
				ELSE 0 
			END										As	EsVehiculoDetenido,
			A.CODVEHICULODEPOSIADO					As	VehiculoDepositado,
			A.CODIGO_AUTORIDAD_REGISTRA				As	Autoridad,
			'SplitInterviniente'					As	SplitInterviniente,
			CAST('00000000-0000-0000-0000-000000000000' AS UNIQUEIDENTIFIER)		AS	Codigo,
			A.IDINT									As	CodigoIntervinienteGestion			
	FROM	DCAROBJ									As	A		-- Datos Boleta tránsito
	WHERE	A.CODOBJ								=	'BOL'

END
GO
