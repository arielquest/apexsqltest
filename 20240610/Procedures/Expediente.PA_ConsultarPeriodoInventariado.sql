SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			    <1.0>
-- Autor:				<Oscar Sanchez Hernandez>
-- Fecha Creación:		<15/12/2022>
-- Descripcion:			<Obtiene todos los periodos de inventario asociados al contexto en donde se encuentre logueado el funcionario.>
-- Modificado:          <Aaron Ríos Retana - 29-05-2023 - Ajuste por hallazgo en pruebas de carga, bloqueos en tablas, se agrega el WITH (NOLOCK) en las tablas faltantes >
-- =================================================================================================================================================

CREATE     PROCEDURE [Expediente].[PA_ConsultarPeriodoInventariado] 
	@CodigoContexto				varchar(4)
AS

BEGIN

	DECLARE	@L_TC_CodContexto			                varchar(4)  = @CodigoContexto

	SELECT 

	 EPI.TU_CodPeriodo as Codigo,
	 EPI.TC_CodContexto AS CodigoContexto,
	 EPI.TC_NombrePeriodo AS NombrePeriodo,
     EPI.TF_Fechainicio AS FechaInicial,
	 EPI.TF_FechaFinal  AS FechaFinal

	FROM			Expediente.PeriodoInventariado	 AS		EPI WITH (NOLOCK) 
	
	WHERE			EPI.TC_CodContexto				=		@L_TC_CodContexto

	ORDER BY 		EPI.TF_FechaFinal DESC

END
GO
