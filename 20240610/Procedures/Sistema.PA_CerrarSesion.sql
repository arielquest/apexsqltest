SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<27/10/2015>
-- Descripcion:		<Cerrar una sesiones abiertas en un equipo.>
-- =============================================
-- Modificacion		<> <Jonathan Aguilar Navarro > <Se realiza el cambio de oficina por contexto>
CREATE PROCEDURE [Sistema].[PA_CerrarSesion] 
	@Usuario		varchar(30)	= Null, 
	@CodContexto	varchar(4)	= Null, 
	@Equipo			varchar(20) = Null
AS
BEGIN
	if @Usuario Is Not Null And @CodContexto Is Not Null And @Equipo Is Null
	Begin
		Update	Sistema.SesionUsuario
		Set		TF_CierreSesion = GetDate(),	
				TB_Activo		= 0
		Where	TC_Usuario		= @Usuario
		And		TC_CodContexto	= @CodContexto
	End
	Else if @Usuario Is Not Null And @CodContexto Is Not Null And @Equipo Is Not Null
	Begin
		Update	Sistema.SesionUsuario
		Set		TF_CierreSesion = GetDate(),	
				TB_Activo		= 0
		Where	TC_Usuario		= @Usuario
		And		TC_CodContexto	= @CodContexto
		And		TC_Equipo		= @Equipo
	End
END
GO
