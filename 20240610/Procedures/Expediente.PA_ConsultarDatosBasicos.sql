SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<28/10/2015>
-- Descripción :			<Permite Consultar los datos básicos de un expediente> 
-- =================================================================================================================================================
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodDelito, TC_CodClaseAsunto y TC_CodCategoriaDelito a TN_CodDelito, TN_CodClaseAsunto y  y TN_CodCategoriaDelito de acuerdo al tipo de dato>
-- Modificación:			<19/01/2018> <Andrés Díaz> <Se tabula el PA. Se cambia LEFT JOIN la consulta de delito.>
-- Modificación:			<13/03/2018> <Andrés Díaz> <Se agrega WITH(NOLOCK) a todas las tablas de la consulta.>
-- Modificación:			<Jonathan Aguilar Navarro> <08/01/2019> <Se agrega a la consulta el expediente acumulado> 
-- Modificación:			<Jonathan Aguilar Navarro> <29/03/2019> <Se modifica por cambios en la estructura debido a la Creación de Expediente> 
-- Modificación:            <Aida E Siles Rojas> <28/05/2020> <Se cambia a Left Join la consulta tipo viabilidad ya que es un dato no requerido en la creación expediente>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarDatosBasicos]
	@NumeroExpediente VARCHAR (14)
AS
BEGIN
	DECLARE @L_TC_NumeroExpediente	VARCHAR(14) = @NumeroExpediente

	SELECT		A.TC_NumeroExpediente			AS	Numero,
				A.TF_Hechos						AS	FechaHechos, 
				A.TB_Confidencial				AS	Confidencial,
				'Split'							AS	Split, 
				D.TN_CodDelito					AS	Codigo,
				D.TC_Descripcion				AS	Descripcion, 
				'Split'							AS	Split,
				E.TN_CodCategoriaDelito			AS	Codigo, 
				E.TC_Descripcion				AS	Descripcion,
				'Split'							As Split,
				C.TC_CodContexto				AS Codigo,
				C.TC_Descripcion				As Descripcion,
				'Split'							As Split,
				G.TC_CodOficina					As Codigo,
				G.TC_Nombre						As Descripcion,
				'Split'							As Split,
				H.TN_CodTipoViabilidad			As Codigo,
				H.TC_Descripcion				AS Descripcion,
				'Split'							AS	Split,
				F.TC_NumeroExpedienteAcumula	As ExpedienteAcumula

	FROM        Expediente.Expediente			AS	A WITH(NOLOCK)
	left  join	Historico.ExpedienteAcumulacion	As  F WITH (NOLOCK)
	ON			F.TC_NumeroExpediente			=   A.TC_NumeroExpediente  
	And			(F.TF_InicioAcumulacion			=	(Select max(A.TF_InicioAcumulacion) 
													 from	Historico.ExpedienteAcumulacion A
													 where	F.TC_NumeroExpediente = @L_TC_NumeroExpediente
													 and	F.TF_FinAcumulacion is null))
	LEFT JOIN	Catalogo.Delito					AS	D WITH(NOLOCK)
	ON			D.TN_CodDelito					=	A.TN_CodDelito
	LEFT JOIN	Catalogo.CategoriaDelito		AS	E WITH(NOLOCK)
	ON			E.TN_CodCategoriaDelito			=	D.TN_CodCategoriaDelito
	INNER JOIN	Catalogo.Contexto				As	C With(NoLock)
	ON			C.TC_CodContexto				=	A.TC_CodContextoCreacion
	INNER JOIN	Catalogo.Oficina				As	G With(NoLock)
	ON			G.TC_CodOficina					=	C.TC_CodOficina
	LEFT  JOIN  Catalogo.TipoViabilidad			As	H With(NoLock)
	ON			H.TN_CodTipoViabilidad			=	A.TN_CodTipoViabilidad
	WHERE		A.TC_NumeroExpediente			=	@L_TC_NumeroExpediente;

END
GO
