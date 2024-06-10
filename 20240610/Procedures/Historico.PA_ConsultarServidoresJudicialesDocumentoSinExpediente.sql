SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Agilar Navarro>
-- Fecha de creación:		<03/10/2018>
-- Descripción :			<Permite consultar los usuarios del contexto que han creado o recibido un documento sin expediente>

CREATE PROCEDURE [Historico].[PA_ConsultarServidoresJudicialesDocumentoSinExpediente]
	@CodContexto	varchar(4) = null
As
Begin
	Select	distinct B.TC_UsuarioRed					AS Usuario,
			B.TC_Nombre									AS Nombre,
			B.TC_PrimerApellido							AS PrimerApellido,
			B.TC_SegundoApellido						AS SegundoApellido,
			B.TC_UsuarioRed								AS UsuarioRed	
	from	Historico.ArchivoSinExpedienteMovimiento	As	A with(Nolock)
	Inner Join Catalogo.Funcionario						AS	B With(NoLock)
	on		B.TC_UsuarioRed								=	A.TC_UsuarioRed	
	Inner Join Catalogo.Contexto						AS	C With(Nolock)
	On		C.TC_CodContexto							=	A.TC_CodContexto			
	where   A.TC_CodContexto							=	coalesce(@CodContexto,A.TC_CodContexto)
	and	    (A.TC_Movimiento						    =  'C' or A.TC_Movimiento = 'R')

End
GO
