SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero>
-- Fecha de creación:	<27/10/2022>
-- Descripción:			<Permite consultar un registro en la tabla: IntervinienteMedidaResolucion por Codigo Resolucion o por Codigo Medida>
-- ==================================================================================================================================================================================
-- Modificación:		<24/11/2022><Karol Jiménez Sánchez><Se agrega a la consulta el código de archivo de la resolución>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE	[Expediente].[PA_ConsultarIntervinienteMedidaResolucion]
	@CodResolucion		UNIQUEIDENTIFIER = NULL,
	@CodMedida			UNIQUEIDENTIFIER = NULL
AS
BEGIN
	--Variables
	DECLARE		@L_TU_CodResolucion						 UNIQUEIDENTIFIER = @CodResolucion,
				@L_TU_CodMedida							 UNIQUEIDENTIFIER = @CodMedida

	--Lógica
	SELECT		A.TU_CodMedida							 CodigoMedida,
				'splitResolucion'						 splitResolucion,
				B.TU_CodResolucion						 CodigoResolucion,	
				B.TF_FechaResolucion					 FechaResolucion,
				B.TU_CodArchivo							 Codigo,
				'splitTipoResolucion'					 splitTipoResolucion,
				D.TN_CodTipoResolucion					 Codigo,
				D.TC_Descripcion						 Descripcion,
				'splitResultadoResolucion'				 splitResultadoResolucion,
				C.TN_CodResultadoResolucion				 Codigo,
				C.TC_Descripcion						 Descripcion				
				
	FROM		Expediente.IntervinienteMedidaResolucion A WITH (NOLOCK)	
	INNER JOIN	Expediente.Resolucion					 B WITH (NOLOCK)
	ON			B.TU_CodResolucion						 = A.TU_CodResolucion
	INNER JOIN  Catalogo.ResultadoResolucion			 C WITH (NOLOCK)
	ON			C.TN_CodResultadoResolucion				 = B.TN_CodResultadoResolucion
	INNER JOIN  Catalogo.TipoResolucion					 D WITH (NOLOCK)
	ON			D.TN_CodTipoResolucion					 = B.TN_CodTipoResolucion
	
	WHERE	    A.TU_CodResolucion						 = COALESCE(@L_TU_CodResolucion, A.TU_CodResolucion)
	AND			A.TU_CodMedida							 = COALESCE(@L_TU_CodMedida, A.TU_CodMedida)					
END
GO
