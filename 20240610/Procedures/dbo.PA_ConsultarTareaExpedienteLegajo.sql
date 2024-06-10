SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================        
-- Versión:			<1.0>        
-- Creado por:		<Jose Gabriel Cordero Soto>        
-- Fecha creación:  <12/03/2021>        
-- Descripción :    <Consultar Tarea por Codigo Tarea, Tipo Puesto Trabajo>         
-- ==================================================================================================================================================================================    
CREATE PROCEDURE [dbo].[PA_ConsultarTareaExpedienteLegajo]
(
	@CodigoTarea				INT,
	@CodigoContexto				VARCHAR(4) = NULL,
	@CodigoTipoPuestoTrabajo	SMALLINT   = NULL
)
AS
BEGIN

--*****************************************************************************************************************
--DECLARACION DE VARIABLES
DECLARE @L_CodigoTarea				INT				= @CodigoTarea,
		@L_CodigoContexto			VARCHAR(4)		= @CodigoContexto,
		@L_CodigoTipoPuesto			SMALLINT		= @CodigoTipoPuestoTrabajo	
		

--*****************************************************************************************************************
--CONSULTA FINAL
SELECT		A.TU_CodTareaPendiente					Codigo, 
			A.TF_Recibido							FechaRecibido, 
			A.TF_Vence								FechaVence, 			
			'splitExpediente'						splitExpediente,
			A.TC_NumeroExpediente					Numero, 
			'splitLegajo'							splitLegajo,
			A.TU_CodLegajo							Codigo,
			'splitTareaRealizar'					splitTareaRealizar,
			A.TN_CodTarea							Codigo
			

FROM		Expediente.TareaPendiente				A WITH(NOLOCK)
INNER JOIN  Catalogo.TareaContextoTipoPuestoTrabajo B WITH(NOLOCK)
ON			A.TN_CodTarea							= B.TN_CodTarea
AND			B.TC_CodContexto						= ISNULL(@CodigoContexto, B.TC_CodContexto)
AND			B.TN_CodTipoPuestoTrabajo				= ISNULL(@CodigoTipoPuestoTrabajo, B.TN_CodTipoPuestoTrabajo)

WHERE		A.TF_Vence								IS NULL
OR			A.TF_Vence								>= SYSDATETIME()
AND			A.TN_CodTarea							= @L_CodigoTarea

END
GO
