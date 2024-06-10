SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<14/09/2017>
-- Descripción:				<Consulta las comunicaciones de una Oficina Judicial las cuales sde deben devolver. Además este procedimiento antes de devolver las comunicaciones, debe actualizar el estado de cada comunicación, el estado debe actualizarse a Estado = Entregada > 
-- Modificación:            <Tatiana Flores><21/08/2018> Se utiliza la tabla Contexto en lugar de la tabla Oficina
-- Modificación:            <Cristian Cerdas><25/09/2020> Se elimina la relación de tabla Comunicacion.Comunicacion.Legajo por número de Expediente
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarComunicacionesDevolver]
(
	@CodigoComunicacion uniqueidentifier
)
AS
BEGIN

	Create Table	#ComunicacionTemp
	(
		Codigo					uniqueidentifier,
		ConsecutivoComunicacion	varchar(35),
		Nue						char(14),
		TipoMedio				varchar(50),
		Valor					varchar(350),
		NombreOficina			varchar(255),
		NombreOCJ				varchar(255),
		TipoComunicacion		char(1),
		Resultado				char(1),
		MotivoResultado			varchar(150)
	)

	Insert Into	#ComunicacionTemp
	Select	C.TU_CodComunicacion,		C.TC_ConsecutivoComunicacion,	
			C.TC_NumeroExpediente,		MC.TC_Descripcion,				
			C.TC_Valor,					OE.TC_Nombre,					
			OC.TC_Nombre,				C.TC_TipoComunicacion,	
			C.TC_Resultado,				MR.TC_Descripcion		
				
	From	Comunicacion.Comunicacion						C	WITH(NOLOCK)

	Join	[Catalogo].[Contexto]						    CO WITH(NOLOCK)
	ON		CO.TC_CodContexto								= C.TC_CodContexto

	JOIN	[Catalogo].[Oficina]						    OE WITH(NOLOCK)
	ON		OE.TC_CodOficina							    = CO.TC_CodOficina

	JOIN	[Catalogo].[Contexto]							COCJ WITH(NOLOCK) 
	ON		COCJ.TC_CodContexto								= C.TC_CodContextoOCJ

	JOIN	[Catalogo].[Oficina]							OC WITH(NOLOCK) 
	ON		OC.TC_CodOficina								= COCJ.TC_CodOficina
	
	Join	Catalogo.TipoMedioComunicacion					MC	WITH(NOLOCK)
	On		MC.TN_CodMedio									=	C.TC_CodMedio

	Join	Catalogo.MotivoResultadoComunicaciOnJudicial	MR	WITH(NOLOCK)
	On		MR.TN_CodMotivoResultado						=	C.TN_CodMotivoResultado

	Where	C.TC_Estado					=	'I'
	And		C.TC_Resultado				Is Not Null
	And		C.TC_CodContexto			=	@CodigoComunicacion

	Update	C	
	Set		C.TC_Estado					=	'J',
			C.TF_FechaDevolucion		=	GETDATE(),
			C.TF_Actualizacion			=	GETDATE()
	From	Comunicacion.Comunicacion	As	C
	Join	#ComunicacionTemp			As	CT
	On		CT.Codigo					=	C.TU_CodComunicacion
	Where	C.TC_Estado					=	'I'
	And		C.TC_Resultado				Is Not Null
	And		C.TC_CodContexto			=	@CodigoComunicacion

	Select	Codigo,						ConsecutivoComunicacion		
			Nue,						TipoMedio,
			Valor,						NombreOficina,
			NombreOCJ,					TipoComunicacion,
			Resultado,					MotivoResultado
	From	#ComunicacionTemp

	If(OBJECT_ID('tempdb..#ComunicacionTemp') Is Not Null)
	Begin
		Drop Table #ComunicacionTemp
	End

END


GO
