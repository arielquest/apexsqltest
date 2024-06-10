SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<17/09/2020>
-- Descripción :			<Permite eliminar la firma holográfica de un funcionario> 
-- ================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarFirmaFuncionario]

	@UsuarioRed			varchar(30)

AS  
BEGIN  
	--Variables
	DECLARE	@L_TC_UsuarioRed			VARCHAR(30)		= @UsuarioRed

	--Lógica
	Update	Catalogo.Funcionario
	Set		TU_CodFirma				=	NULL
	Where	TC_UsuarioRed			=	@L_TC_UsuarioRed

End

GO
