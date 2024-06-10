SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<06/08/2019>
-- Descripción :			<Permite consultar las carpetas>
-- =================================================================================================================================================
-- Modificación:		    <08/07/2021> <Josué Quirós Batista> <Se agrega la consulta de las observaciones de la carpeta a la consulta.>
-- =================================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarDatosGeneralesCarpeta]
	@NRD				varchar(14),
	@NumeroExpediente	Char(14)
As
Begin
If(@NRD is NULL)
Begin
		Select		A.TC_NRD					As	NRD,
					A.TC_NumeroExpediente		As	NumeroExpediente,
					A.TF_Creacion				As	FechaCreacion,
					A.TC_Observaciones          As  Observaciones,
					'Split'						As	Split,
					A.TN_CodTipoCaso			As	CodigoTipoCaso,										
					B.TC_Descripcion			As	TipoCasoDescrip,					
					A.TC_CodContexto			As	CodigoContexto,
					C.TC_Descripcion			As	ContextoDescrip,
					D.TC_CodMateria				As	CodigoMateria,
					D.TC_Descripcion			As	MateriaDescrip
		From		DefensaPublica.Carpeta		A	With (NoLock)
		Inner Join	Catalogo.TipoCaso			B	With (NoLock)
		On			A.TN_CodTipoCaso			=	B.TN_CodTipoCaso
		Inner Join	Catalogo.Contexto			C	With (NoLock)
		On			A.TC_CodContexto			=	C.TC_CodContexto
		Inner Join	Catalogo.Materia			D	With (NoLock)
		On			C.TC_CodMateria				=	D.TC_CodMateria
		Where		A.TC_NumeroExpediente		=	@NumeroExpediente
	End		
Else
	Begin
		Select		A.TC_NRD					As	NRD,
					A.TC_NumeroExpediente		As	NumeroExpediente,
					A.TF_Creacion				As	FechaCreacion,
					A.TC_Observaciones          As  Observaciones,
					'Split'						As	Split,
					A.TN_CodTipoCaso			As	CodigoTipoCaso,										
					B.TC_Descripcion			As	TipoCasoDescrip,					
					A.TC_CodContexto			As	CodigoContexto,
					C.TC_Descripcion			As	ContextoDescrip,
					D.TC_CodMateria				As	CodigoMateria,
					D.TC_Descripcion			As	MateriaDescrip
		From		DefensaPublica.Carpeta		A	With (NoLock)
		Inner Join	Catalogo.TipoCaso			B	With (NoLock)
		On			A.TN_CodTipoCaso			=	B.TN_CodTipoCaso
		Inner Join	Catalogo.Contexto			C	With (NoLock)
		On			A.TC_CodContexto			=	C.TC_CodContexto
		Inner Join	Catalogo.Materia			D	With (NoLock)
		On			C.TC_CodMateria				=	D.TC_CodMateria
		Where		A.TC_NRD					=	@NRD
	End	 
End
GO
