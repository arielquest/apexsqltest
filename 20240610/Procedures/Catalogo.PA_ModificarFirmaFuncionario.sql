SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Méndez Ch>
-- Fecha de creación:		<28/10/2020>
-- Descripción :			<Permite asociar la firma holográfica a un funcionario> 
-- ================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarFirmaFuncionario]
	@UsuarioRed			varchar(30),
	@CodFirma			uniqueidentifier

AS  
BEGIN  
	--Variables
	DECLARE	@L_UsuarioRed			varchar(30)			=	@UsuarioRed
	DECLARE	@L_CodFirma				uniqueidentifier	=	@CodFirma

	--Lógica
	Update	Catalogo.Funcionario
	Set		TU_CodFirma				=	@L_CodFirma
	Where	TC_UsuarioRed			=	@L_UsuarioRed

End

GO
