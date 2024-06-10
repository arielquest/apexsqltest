SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Historico].[PA_ConsultarHistoricoLaborPersonalJudicial]
	@UsuarioRed       VARCHAR(30),
	@Anno             SMALLINT,
	@Mes		      SMALLINT,
	@CodContexto      VARCHAR(4)
AS
BEGIN
--Variables
	DECLARE	@L_TC_UsuarioRed     VARCHAR(30) = @UsuarioRed	       
	DECLARE	@L_TN_Anno           SMALLINT    = @Anno
	DECLARE	@L_TN_Mes            SMALLINT    = @Mes
	DECLARE	@L_TC_CodContexto    VARCHAR(21) = @CodContexto

	SELECT HL.TU_CodLabor                  AS CodigoHistorico,           HL.TN_Anno            AS Anno,            HL.TN_Mes               AS Mes,
		   HL.TC_CodContexto               AS CodContexto,               HL.TN_HorasOficina    AS HorasOficina,    HL.TN_HorasFueraOficina AS HorasFueraOficina,
		   HL.TF_FechaRegistro             AS FechaRegistro,	 					   
		   'SplitLabor'                    AS SplitLabor,									   						 				   
		   CL.TN_CodLaborPersonalJudicial  AS CodLaborPersonalJudicial,  CL.TC_Descripcion     AS Descripcion,     CL.TF_InicioVigencia    AS FechaActivacion,
		   CL.TF_FinVigencia               AS FechaDesactivacion,         					   						 	   				   
		   'SplitFuncionario'              AS SplitFuncionario,            					   						 		   			   
		   CF.TC_Nombre  				   AS  Nombre,                   CF.TC_PrimerApellido  AS PrimerApellido,  CF.TC_SegundoApellido   AS SegundoApellido,
		   CF.TC_CodPlaza			       AS  CodigoPlaza,              CF.TF_Inicio_Vigencia AS FechaActivacion, CF.TF_Fin_Vigencia      AS	FechaDesactivacion,
		   CF.TC_UsuarioRed                AS UsuarioRed               
	FROM  Historico.LaborRealizadaPersonalJudicial AS HL WITH(NOLOCK)
	JOIN  Catalogo.LaborPersonalJudicial           AS CL WITH(NOLOCK)
	ON    HL.TN_CodLaborPersonalJudicial           =  CL.TN_CodLaborPersonalJudicial
	JOIN  Catalogo.Funcionario                     AS CF WITH(NOLOCK)
	ON    HL.TC_UsuarioRed                         =  CF.TC_UsuarioRed 
	WHERE HL.TN_Anno                              =	 COALESCE(@L_TN_Anno,          HL.TN_Anno)
	AND   HL.TN_Mes                               =	 COALESCE(@L_TN_Mes,           HL.TN_Mes)
	AND   HL.TC_UsuarioRed                        =  COALESCE(@L_TC_UsuarioRed,    HL.TC_UsuarioRed)
	AND   HL.TC_CodContexto					      =  @L_TC_CodContexto
	ORDER BY HL.TN_Anno DESC, HL.TN_Mes ASC,CF.TC_Nombre
	END
GO
