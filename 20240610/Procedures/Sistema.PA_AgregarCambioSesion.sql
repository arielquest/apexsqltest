SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<26/10/2015>
-- Descripcion:		<Crear un nuevo registro para un cambio de fecha de sesión.>
-- ====================================================================================================================================================================================
-- Modificación:	<31/10/2019> <Isaac Dobles Mata> <Se modifica para ajustarse a estructura de Contexto>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Sistema].[PA_AgregarCambioSesion] 
	@Usuario		varchar(30), 
	@CodContexto	varchar(4), 
	@Equipo			varchar(20),
	@FechaTramite	datetime2,
	@FechaSesion	datetime2,
	@FechaCierre	datetime2,
	@Activo			bit
AS
BEGIN
	INSERT INTO Sistema.SesionUsuario
	(
		TC_Usuario,	TC_CodContexto,		TC_Equipo,	TF_Tramite,
		TF_Sesion,	TF_CierreSesion,	TB_Activo
	)
	VALUES
	(
		@Usuario,		@CodContexto,	@Equipo,	@FechaTramite,		
		@FechaSesion,	@FechaCierre,	@Activo
	)
END
GO
