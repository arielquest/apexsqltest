SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<19/06/2020>
-- Descripcion:			<Ingresa un registro en el histórico de fases del expediente.>
-- Modificado:          <08/12/2020> <Roger Lara > <Se elmina el campo Fecha fin, y se renombra fecha inicio a Fecha Fase>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteFase] 
	@CodExpedienteFase		    uniqueidentifier,
	@CodFase					smallint,
	@NumeroExpediente			char(14), 
	@CodigoContexto				varchar(4),
	@FechaFase					datetime2(7)=null,
	@UsuarioRed					varchar(30)
AS

BEGIN
    DECLARE @L_TU_ExpedienteFase        uniqueidentifier = @CodExpedienteFase
	DECLARE	@L_TN_CodFase				smallint	     = @CodFase
	DECLARE	@L_TC_NumeroExpediente		char(14)	     = @NumeroExpediente
	DECLARE	@L_TC_CodContexto			varchar(4)       = @CodigoContexto
	DECLARE @L_TF_Fase					datetime2(7)     = @FechaFase
	DECLARE	@L_TC_UsuarioRed			varchar(30)	     = @UsuarioRed


	INSERT INTO Historico.ExpedienteFase
	(
		TU_CodExpedienteFase,
		TN_CodFase,		
		TC_NumeroExpediente,	
		TC_CodContexto,
		TF_Fase,
		TC_UsuarioRed
	)
	VALUES
	(
		@L_TU_ExpedienteFase,
		@L_TN_CodFase,
		@L_TC_NumeroExpediente,
		@L_TC_CodContexto,
		 COALESCE(@L_TF_Fase,getdate()),
		@L_TC_UsuarioRed
	)

END
GO
