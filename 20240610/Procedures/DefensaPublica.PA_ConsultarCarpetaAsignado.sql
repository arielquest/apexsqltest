SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles Rojas>
-- Fecha de creación:	<13/11/2019>
-- Descripción:			<Permite consultar un registro en la tabla de acuerdo al asignado: Carpeta.>
-- ==================================================================================================================================================================================
CREATE Procedure [DefensaPublica].[PA_ConsultarCarpetaAsignado]
	@TC_NRD					varchar(14)	= NULL,
	@TC_NumeroExpediente	Char(14)	= NULL,
	@TC_CodContexto			varchar(4),
	@TC_CodPuestoTrabajo	varchar(14)
As
Begin
	--Variables
	Declare	@L_TC_NRD				varchar(14)	= @TC_NRD,
			@L_TC_NumeroExpediente	Char(14)	= @TC_NumeroExpediente,
			@L_TC_CodContexto		varchar(4)  = @TC_CodContexto,
			@L_TC_CodPuestoTrabajo	varchar(14)	= @TC_CodPuestoTrabajo
	--Lógica
	If(@L_TC_NRD is NULL)
		Begin
			Select		Distinct A.TC_NRD				As	NRD,		
						A.TC_NumeroExpediente			As	NumeroExpediente,
						A.TF_Creacion					As	FechaCreacion,
						'Split'							As	Split,
						A.TC_CodContexto				As	CodigoContexto,
						B.TC_Descripcion				As	ContextoDescrip,
						C.TC_CodMateria					As	CodigoMateria,
						C.TC_Descripcion				As	MateriaDescrip,
						D.TN_CodTipoCaso				As	CodigoTipoCaso,
						D.TC_Descripcion				As	TipoCasoDescrip
			From		DefensaPublica.Carpeta			A	With (NoLock)
			Inner Join	Catalogo.Contexto				B	With (NoLock)
			On			A.TC_CodContexto				=	B.TC_CodContexto
			Inner Join	Catalogo.Materia				C	With (NoLock)
			On			B.TC_CodMateria					=	C.TC_CodMateria
			Inner Join	Catalogo.TipoCaso				D	With (NoLock)
			On			A.TN_CodTipoCaso				=	D.TN_CodTipoCaso
			Inner Join	DefensaPublica.Representacion   E	With (NoLock)
			On			A.TC_NRD						=	E.TC_NRD
			Inner Join	DefensaPublica.Asignacion		F	With (NoLock)
			On			E.TU_CodRepresentacion			=	F.TU_CodRepresentacion
			And			F.TC_CodPuestoTrabajo			=	@L_TC_CodPuestoTrabajo
			And			F.TF_Inicio_Vigencia			<=	GETDATE()
			And			(F.TF_Fin_Vigencia Is Null		Or	F.TF_Fin_Vigencia >	GETDATE())
			Where		A.TC_NumeroExpediente			=	@L_TC_NumeroExpediente
			And			A.TC_CodContexto				=	@L_TC_CodContexto				
		End
	Else
		Begin
			Select		Distinct A.TC_NRD				As	NRD,		
						A.TC_NumeroExpediente			As	NumeroExpediente,
						A.TF_Creacion					As	FechaCreacion,
						'Split'							As	Split,
						A.TC_CodContexto				As	CodigoContexto,
						B.TC_Descripcion				As	ContextoDescrip,
						C.TC_CodMateria					As	CodigoMateria,
						C.TC_Descripcion				As	MateriaDescrip,
						D.TN_CodTipoCaso				As	CodigoTipoCaso,
						D.TC_Descripcion				As	TipoCasoDescrip
			From		DefensaPublica.Carpeta			A	With (NoLock)
			Inner Join	Catalogo.Contexto				B	With (NoLock)
			On			A.TC_CodContexto				=	B.TC_CodContexto
			Inner Join	Catalogo.Materia				C	With (NoLock)
			On			B.TC_CodMateria					=	C.TC_CodMateria
			Inner Join	Catalogo.TipoCaso				D	With (NoLock)
			On			A.TN_CodTipoCaso				=	D.TN_CodTipoCaso
			Inner Join	DefensaPublica.Representacion   E	With (NoLock)
			On			A.TC_NRD						=	E.TC_NRD
			Inner Join	DefensaPublica.Asignacion		F	With (NoLock)
			On			E.TU_CodRepresentacion			=	F.TU_CodRepresentacion
			And			F.TC_CodPuestoTrabajo			=	@L_TC_CodPuestoTrabajo
			And			F.TF_Inicio_Vigencia			<=	GETDATE()
			And			(F.TF_Fin_Vigencia Is Null		Or	F.TF_Fin_Vigencia >	GETDATE())
			Where		A.TC_NRD						=	@L_TC_NRD
			And			A.TC_CodContexto				=	@L_TC_CodContexto
		End

End
GO
