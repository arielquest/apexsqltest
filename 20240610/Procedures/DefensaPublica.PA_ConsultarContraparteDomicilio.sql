SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<13/12/2019>
-- Descripción:			<Permite consultar un registro en la tabla: ContraparteDomicilio.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ConsultarContraparteDomicilio]
	@CodContraparte		UNIQUEIDENTIFIER	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodContraparte		UNIQUEIDENTIFIER	= @CodContraparte
			
	--Lógica
	DECLARE @TempCodigo AS TABLE (Codigo UNIQUEIDENTIFIER NOT NULL);

	If (@L_TU_CodContraparte Is Not Null)
	Begin
		Insert Into	@TempCodigo
		Select		A.TU_CodDomicilio
		From		DefensaPublica.ContraparteDomicilio		As A With(NoLock)
		Inner Join	DefensaPublica.Contraparte				As B With(NoLock)
		On			B.TU_CodContraparte						= A.TU_CodContraparte
		Where		A.TU_CodContraparte						= @L_TU_CodContraparte;
	End
	Else If (@L_TU_CodContraparte Is Null)
	Begin
		Insert Into	@TempCodigo
		Select		A.TU_CodDomicilio
		From		DefensaPublica.ContraparteDomicilio		As A With(NoLock)
		Inner Join	DefensaPublica.Contraparte				As B With(NoLock)
		On			B.TU_CodContraparte						= A.TU_CodContraparte
	End

	SELECT		A.TU_CodDomicilio							AS	CodigoDomicilio,
				A.TU_CodContraparte							AS	CodContraparte,
				A.TC_Direccion								AS	Direccion,
				A.TB_Activo									AS	Activo,
				'Split'										AS	Split,
				A.TN_CodTipoDomicilio						AS	CodigoTipoDomicilio,
				B.TC_Descripcion							AS	TipoDomicilioDescrip,
				A.TC_CodPais								AS	CodigoPais,
				C.TC_Descripcion							AS	PaisDescrip,
				C.TB_RequiereRegionalidad					AS	RequiereRegionalidad,
				A.TN_CodProvincia							AS	CodigoProvincia,
				D.TC_Descripcion							AS	ProvinciaDescrip,
				A.TN_CodCanton								AS	CodigoCanton,
				E.TC_Descripcion							AS	CantonDescrip,
				A.TN_CodDistrito							AS	CodigoDistrito,
				F.TC_Descripcion							AS	DistritoDescrip,
				A.TN_CodBarrio								AS	CodigoBarrio,
				G.TC_Descripcion							AS	BarrioDescrip
	FROM		DefensaPublica.ContraparteDomicilio			AS	A WITH (NOLOCK)	
	INNER JOIN	Catalogo.TipoDomicilio						AS	B WITH (NOLOCK)
	ON			A.TN_CodTipoDomicilio						=	B.TN_CodTipoDomicilio
	INNER JOIN	Catalogo.Pais								AS	C WITH (NOLOCK)
	ON			A.TC_CodPais								=	C.TC_CodPais
	LEFT JOIN	Catalogo.Provincia							AS	D WITH (NOLOCK)
	ON			A.TN_CodProvincia							=	D.TN_CodProvincia
	LEFT JOIN	Catalogo.Canton								AS	E WITH (NOLOCK)
	ON			A.TN_CodCanton								=	E.TN_CodCanton
	AND			A.TN_CodProvincia							=	E.TN_CodProvincia
	LEFT JOIN	Catalogo.Distrito							AS	F WITH (NOLOCK)
	ON			A.TN_CodDistrito							=	F.TN_CodDistrito
	AND			A.TN_CodCanton								=	F.TN_CodCanton
	AND			A.TN_CodProvincia							=	F.TN_CodProvincia
	LEFT JOIN	Catalogo.Barrio								AS	G WITH (NOLOCK)
	ON			A.TN_CodBarrio								=	G.TN_CodBarrio
	AND			A.TN_CodDistrito							=	G.TN_CodDistrito
	AND			A.TN_CodCanton								=	G.TN_CodCanton
	AND			A.TN_CodProvincia							=	G.TN_CodProvincia
	INNER JOIN	@TempCodigo									AS	H
	ON			A.TU_CodDomicilio							=	H.Codigo				
				

END
GO
