SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<19/06/2020>
-- Descripcion:			<Consulta la fase más reciente de un expediente.>
-- Modificado:          <08/12/2020> <Roger Lara > <Se elmina el campo Fecha fin, y se le agrega parametro de contexto>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteFase] 
	@NumeroExpediente			char(14),
	@CodigoContexto				varchar(4)

AS

BEGIN

	DECLARE	@L_TC_NumeroExpediente						char(14)	= @NumeroExpediente
	DECLARE	@L_TC_CodContexto			                varchar(4)  = @CodigoContexto
	SELECT 
	TOP 1 (TU_CodExpedienteFase)						As Codigo,
	'Split'												As		Split,
	EF.TN_CodFase										As		CodigoFase,
	F.TC_Descripcion									As		DescripcionFase

	FROM			Historico.ExpedienteFase			EF
	INNER JOIN		Catalogo.Fase						F		With(NoLock)
	ON				EF.TN_CodFase						=		F.TN_CodFase
	
	WHERE			EF.TC_NumeroExpediente				=		@L_TC_NumeroExpediente
	AND				EF.TC_CodContexto					=       @L_TC_CodContexto

	ORDER BY		EF.TF_Fase			               DESC

END
GO
