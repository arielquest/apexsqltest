SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<10/02/2016>
-- Descripción :			<Permite consultar los domicilios de un interviniente.> 
-- =======================================================================================================================================================
-- Modificación:			<15/02/2015> <Andrés Díaz> <Se elimina el campo Telefono de la tabla Domicilio.>
-- Modificación:			<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificación:			<15/02/2018> <Andrés Díaz> <Se agrega filtro por código de legajo.>
-- Modificación:			<22/05/2018> <Andrés Díaz> <Se optimiza la consulta.>
-- Modificación:			<14/09/2018> <Juan Ramirez> <Se elimina el parámetro legajo y consulta desde la tabla intervencion>
-- Modificación:			<08/05/2019> <Andrés Díaz> <En 'Persona.Domicilio' se renombra 'TB_Activo' por 'TB_DomicilioHabitual'.>
-- Modificación:			<11/05/2021> <Ronny Ramírez R.> <Se ajusta problema con domicilios repetidos por no tomar en cuenta el GUID del interviniente>
-- Modificación:			<01/11/2021> <Ronny Ramírez R.> <Se agregan filtros por número de expediente y legajo - PBI: 207314>
-- Modificación				<Ronny Ramírez R.>  <17/07/2023><Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE/ISNULL en el WHERE>
-- =======================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteDomicilio]
	@CodInterviniente	uniqueidentifier 	= NULL,
	@NumeroExpediente	varchar(14)			= NULL,
	@CodLegajo			uniqueidentifier	= NULL
AS
BEGIN

	DECLARE @L_TU_CodInterviniente			uniqueidentifier		= @CodInterviniente,
			@L_TC_NumeroExpediente          varchar(14)				= @NumeroExpediente,
			@L_@CodLegajo					uniqueidentifier		= @CodLegajo

	Select		ID.TU_CodDomicilio					As	CodigoDomicilio,
				D.TC_Direccion						As	Direccion,
				ID.TU_CodInterviniente				As	CodInterviniente,
				D.TB_DomicilioHabitual				As	DomicilioHabitual,
				'Split'								As	Split,
				D.TN_CodTipoDomicilio				As	CodigoTipoDomicilio,
				TD.TC_Descripcion					As	DescripcionTipoDomicilio,
				D.TC_CodPais						As	CodigoPais,
				P.TC_Descripcion					As	DescripcionPais,
				P.TB_RequiereRegionalidad			As	RequiereRegionalidad,
				D.TN_CodProvincia					As	CodigoProvincia,
				PR.TC_Descripcion					As	DescripcionProvincia,
				D.TN_CodCanton						As	CodigoCanton,
				CA.TC_Descripcion					As	DescripcionCanton,
				D.TN_CodDistrito					As	CodigoDistrito,
				DI.TC_Descripcion					As	DescripcionDistrito,
				D.TN_CodBarrio						As	CodigoBarrio,
				BA.TC_Descripcion					As	DescripcionBarrio
	From		Expediente.IntervinienteDomicilio	As	ID With(NoLock)
	Left Join	Persona.Domicilio					As	D With(NoLock)
	On			D.TU_CodDomicilio					=	ID.TU_CodDomicilio
	Inner Join	Catalogo.TipoDomicilio				As	TD With(Nolock)
	On			TD.TN_CodTipoDomicilio				=	D.TN_CodTipoDomicilio
	Inner Join	Catalogo.Pais						As	P With(NoLock)
	On			P.TC_CodPais						=	D.TC_CodPais
	Left Join	Catalogo.Provincia					As	PR With(NoLock)
	On			PR.TN_CodProvincia					=	D.TN_CodProvincia
	Left Join	Catalogo.Canton						As	CA With(NoLock)
	On			CA.TN_CodCanton						=	D.TN_CodCanton
	And			CA.TN_CodProvincia					=	D.TN_CodProvincia
	Left Join	Catalogo.Distrito					As	DI With(NoLock)
	On			DI.TN_CodDistrito					=	D.TN_CodDistrito
	And			DI.TN_CodCanton						=	D.TN_CodCanton
	And			DI.TN_CodProvincia					=	D.TN_CodProvincia
	Left Join	Catalogo.Barrio						As	BA With(NoLock)
	On			BA.TN_CodBarrio						=	D.TN_CodBarrio
	And			BA.TN_CodDistrito					=	D.TN_CodDistrito
	And			BA.TN_CodCanton						=	D.TN_CodCanton
	And			BA.TN_CodProvincia					=	D.TN_CodProvincia
	INNER JOIN	Expediente.Intervencion				AS	I WITH(NOLOCK)
	ON			I.TU_CodInterviniente				=	ID.TU_CodInterviniente
	WHERE		ID.TU_CodInterviniente				=	ISNULL(@L_TU_CodInterviniente, ID.TU_CodInterviniente)
	AND			I.TC_NumeroExpediente				=	ISNULL(@L_TC_NumeroExpediente, I.TC_NumeroExpediente)
	AND			(
					(
						@L_@CodLegajo				IS NOT NULL
						AND
						EXISTS						(
														SELECT	* 
														FROM	Expediente.LegajoIntervencion	AS	LI WITH(NOLOCK) 
														WHERE	LI.TU_CodLegajo					=	@L_@CodLegajo
														AND		LI.TU_CodInterviniente			=	I.TU_CodInterviniente
													)
					)
					OR
						@L_@CodLegajo				IS NULL
				)
	OPTION(RECOMPILE);
END
GO
