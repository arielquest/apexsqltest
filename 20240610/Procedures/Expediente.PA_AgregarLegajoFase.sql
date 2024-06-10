SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Autor:				<Daniel Ruiz Hernández>
-- Fecha Creación:		<15/12/2020>
-- Descripcion:			<Ingresa un registro en el histórico de fases del legajo.>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarLegajoFase] 
	@CodLegajoFase				uniqueidentifier,
	@CodFase					smallint,
	@CodLegajo					uniqueidentifier,
	@CodigoContexto				varchar(4),
	@FechaFase					datetime2(3)=null,
	@UsuarioRed					varchar(30)
AS

BEGIN
    DECLARE @L_TU_LegajoFase			uniqueidentifier	= @CodLegajoFase
	DECLARE	@L_TN_CodFase				smallint			= @CodFase
	DECLARE	@L_TU_CodLegajo				uniqueidentifier	= @CodLegajo
	DECLARE	@L_TC_CodContexto			varchar(4)			= @CodigoContexto
	DECLARE @L_TF_Fase					datetime2(3)		= @FechaFase
	DECLARE	@L_TC_UsuarioRed			varchar(30)			= @UsuarioRed


	INSERT INTO Historico.LegajoFase
	(
		TU_CodLegajoFase, 
		TN_CodFase,	
		TU_CodLegajo,
		TC_CodContexto,
		TF_Fase,
		TC_UsuarioRed,
		TF_Particion
	)
	VALUES
	(
		@L_TU_LegajoFase,
		@L_TN_CodFase,
		@L_TU_CodLegajo,
		@L_TC_CodContexto,
		 COALESCE(@L_TF_Fase,getdate()),
		@L_TC_UsuarioRed,
		getdate()
	)

END
GO
