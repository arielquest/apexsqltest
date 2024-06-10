SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================================
-- Versi¢n:					<1.0>
-- Creado por:				<Fabian Sequeira Gamboa>
-- Fecha de creaci¢n:		<24/05/2021>
-- Descripci¢n:				<Obtener las observaciones de los expedientes y legajos.> 
-- =======================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarObservacionExpedieteLegajo]
(
@NumeroExpediente varchar(14)= null,
@CodLegajo uniqueidentifier = null
)
AS
DECLARE @L_NumeroExpediente AS VARCHAR(14) =@NumeroExpediente;
DECLARE @L_CodLegajo AS uniqueidentifier =@CodLegajo; 
IF @L_NumeroExpediente IS NOT NULL
BEGIN
SELECT	A.TU_CodObservacionExpedienteLegajo		AS CodigoObservacionExpedienteLegajo
		,A.TC_Observacion						AS Observacion
		,A.TF_FechaCreacion						AS FechaCreacion
		,A.TB_Urgente							AS EsUrgente
		, 'SplitExpediente' 					AS SplitExpediente 
		,A.TC_NumeroExpediente					AS Numero
		, 'SplitLegajo' 						AS SplitLegajo 
		,A.TU_CodLegajo							AS Codigo
		,'SplitFuncionario'						As SplitFuncionario  
		,B.TC_UsuarioRed						As UsuarioRed 		
		,B.TC_Nombre							As Nombre			
		,B.TC_PrimerApellido					As PrimerApellido
		,B.TC_SegundoApellido					As SegundoApellido
		,'SplitOtros'							As SplitOtros
		,A.TN_CodEstado							As Estado
	FROM	Expediente.ObservacionExpedienteLegajo	AS	A WITH(NOLOCK)
			INNER JOIN  Catalogo.Funcionario        AS B WITH(NOLOCK)
			ON          A.TC_UsuarioRed             =  B.TC_UsuarioRed
	where		A.TC_NumeroExpediente                   = ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)
				AND	A.TU_CodLegajo			            IS NULL
order by A.TF_FechaCreacion desc
END
IF @L_CodLegajo IS NOT NULL
BEGIN
SELECT	A.TU_CodObservacionExpedienteLegajo		AS CodigoObservacionExpedienteLegajo
		,A.TC_Observacion						AS Observacion
		,A.TF_FechaCreacion						AS FechaCreacion
		,A.TB_Urgente							AS EsUrgente
		, 'SplitExpediente' 					AS SplitExpediente 
		,A.TC_NumeroExpediente					AS Numero
		, 'SplitLegajo' 						AS SplitLegajo 
		,A.TU_CodLegajo							AS Codigo
		,'SplitFuncionario'						As SplitFuncionario  
		,B.TC_UsuarioRed						As UsuarioRed 		
		,B.TC_Nombre							As Nombre			
		,B.TC_PrimerApellido					As PrimerApellido
		,B.TC_SegundoApellido					As SegundoApellido
		,'SplitOtros'							As SplitOtros
		,A.TN_CodEstado							As Estado
	FROM	Expediente.ObservacionExpedienteLegajo	AS	A WITH(NOLOCK)
			INNER JOIN  Catalogo.Funcionario        AS B WITH(NOLOCK)
			ON          A.TC_UsuarioRed             =  B.TC_UsuarioRed
	where		A.TU_CodLegajo = ISNULL(@L_CodLegajo, A.TU_CodLegajo) 			            
order by A.TF_FechaCreacion desc
END
SET ANSI_NULLS ON
GO
