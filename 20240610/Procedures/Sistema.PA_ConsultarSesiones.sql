SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<27/10/2015>
-- Descripción :			<Permite consultar las sesiones de una oficina, usuario y maquina.> 
-- =================================================================================================================================================
-- Modificación:			<23/04/2018> <Jonathan Aguilar Navarro> <Se cambiao el campo TC_CodOficina por TC_CodContexto al igual que el parametro 
--							@CodOficina>
-- =================================================================================================================================================
CREATE PROCEDURE [Sistema].[PA_ConsultarSesiones]
	@Usuario	 varchar(30) = Null, 
	@CodContexto varchar(4)	= Null,
	@Equipo		 varchar(20) = Null,
	@Activo		 bit			= 1
 As
 Begin
	--Todos
	if @Usuario Is Null And @CodContexto Is Null And @Equipo Is Null 
	Begin
		Select	TC_Usuario, TC_CodContexto,		TC_Equipo, TF_Tramite, 
				TF_Sesion,	TF_CierreSesion,	TB_Activo
		From	Sistema.SesionUsuario With(Nolock)
		Where	TB_Activo = @Activo
	End
	--Por Usuario
	Else if @Usuario Is Not Null And @CodContexto Is Null And @Equipo Is Null
	Begin
		Select	TC_Usuario, TC_CodContexto,		TC_Equipo, TF_Tramite, 
				TF_Sesion,	TF_CierreSesion,	TB_Activo
		From	Sistema.SesionUsuario With(Nolock)
		Where	TB_Activo = @Activo
		And		TC_Usuario = @Usuario
	End
	--Por Oficina
	Else if @Usuario Is Null And @CodContexto Is Not Null And @Equipo Is Null
	Begin
		Select	TC_Usuario, TC_CodContexto,		TC_Equipo, TF_Tramite, 
				TF_Sesion,	TF_CierreSesion,	TB_Activo
		From	Sistema.SesionUsuario With(Nolock)
		Where	TB_Activo = @Activo
		And		TC_CodContexto = @CodContexto
	End
	--Por Equipo
	Else if @Usuario Is Null And @CodContexto Is Null And @Equipo Is Not Null
	Begin
		Select	TC_Usuario, TC_CodContexto,		TC_Equipo, TF_Tramite, 
				TF_Sesion,	TF_CierreSesion,	TB_Activo
		From	Sistema.SesionUsuario With(Nolock)
		Where	TB_Activo = @Activo
		And		TC_Equipo = @Equipo
	End
	--Por Usuario y Oficina
	Else if @Usuario Is Not Null And @CodContexto Is Not Null And @Equipo Is Null
	Begin
		Select	TC_Usuario, TC_CodContexto,		TC_Equipo, TF_Tramite, 
				TF_Sesion,	TF_CierreSesion,	TB_Activo
		From	Sistema.SesionUsuario With(Nolock)
		Where	TB_Activo = @Activo
		And		TC_Usuario = @Usuario
		And		TC_CodContexto = @CodContexto
	End
	--Por Usuario, Oficina y Equipo
	Else if @Usuario Is Not Null And @CodContexto Is Not Null And @Equipo Is Not Null
	Begin
		Select	TC_Usuario, TC_CodContexto,		TC_Equipo, TF_Tramite, 
				TF_Sesion,	TF_CierreSesion,	TB_Activo
		From	Sistema.SesionUsuario With(Nolock)
		Where	TB_Activo = @Activo
		And		TC_Usuario = @Usuario
		And		TC_CodContexto = @CodContexto
		And		TC_Equipo = @Equipo
	End
 End

GO
