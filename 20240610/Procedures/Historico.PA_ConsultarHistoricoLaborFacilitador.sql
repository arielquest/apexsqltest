SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Historico].[PA_ConsultarHistoricoLaborFacilitador]
	@CodFacilitador	INT      = NULL,
	@Anno           SMALLINT = NULL,
	@Mes		    SMALLINT = NULL,
	@CodContexto    VARCHAR(4)
AS
BEGIN
--Variables
	DECLARE	@L_TN_CodFacilitador    INT      = @CodFacilitador
	DECLARE	@L_TN_Anno              SMALLINT = @Anno
	DECLARE	@L_TN_Mes               SMALLINT = @Mes
	DECLARE	@L_TC_CodContexto    VARCHAR(21) = @CodContexto

	SELECT HL.TU_CodLaborRealizada    AS CodigoHistorico,      HL.TN_Anno                 AS Anno,                 HL.TN_Mes            AS Mes, 
	       HL.TN_ParticipantesHombres AS ParticipacionHombres, HL.TN_ParticipantesMujeres AS ParticipacionMujeres, HL.TN_TotalRealizado AS TotalRealizado, 
		   HL.TF_FechaRegistro        AS FechaRegistro,
		   'SplitLabor'               AS SplitLabor,		
		   CL.TN_CodLaborFacilitador  AS CodLaborFacilitador,  CL.TC_Descripcion          AS Descripcion,          CL.TF_InicioVigencia  AS FechaActivacion,
		   CL.TF_FinVigencia          AS FechaDesactivacion,   CL.TB_ContabilizaGenero    AS ContabilizaGenero,
		   'SplitFacilitador'         AS SplitFacilitador,	
		   HL.TN_CodFacilitador       AS CodigoFacilitador    
	FROM  Historico.LaborRealizadaFacilitador AS HL  WITH(NOLOCK)
	JOIN  Catalogo.LaborFacilitadorJudicial   AS CL  WITH(NOLOCK)
	ON    HL.TN_CodLaborFacilitador           =  CL.TN_CodLaborFacilitador
	JOIN  Facilitador.Facilitador             AS F   WITH(NOLOCK)
	ON    HL.TN_CodFacilitador                =  F.TN_CodFacilitador
	WHERE HL.TN_Anno                          =	 COALESCE(@L_TN_Anno          ,HL.TN_Anno)
	AND   HL.TN_Mes                           =	 COALESCE(@L_TN_Mes           ,HL.TN_Mes)
	AND   HL.TN_CodFacilitador                =  COALESCE(@L_TN_CodFacilitador,HL.TN_CodFacilitador)
	AND   F.TC_CodContexto					  =  @L_TC_CodContexto
	ORDER BY HL.TN_Anno DESC, HL.TN_Mes ASC,HL.TN_CodFacilitador 
	END
GO
