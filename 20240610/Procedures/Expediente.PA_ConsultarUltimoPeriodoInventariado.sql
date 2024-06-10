SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			    <1.0>
-- Autor:				<Oscar Sanchez Hernandez>
-- Fecha Creación:		<26/12/2022>
-- Descripcion:			<Obtiene el ultimo periodo de inventario vigente asociados al contexto en donde se encuentre logueado el funcionario.>
-- Modificado:          <10-02-2023 - Aarón Ríos Retana - Se realiza ajuste en el where para que compare contra la fecha inicial y final del día, no con las horas registradas>
-- Modificado:          <Aaron Rios Retana - 29-05-2023 - Ajuste por hallazgo en pruebas de carga, bloqueos en tablas, se agrega el WITH (NOLOCK) en las tablas faltantes >
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarUltimoPeriodoInventariado] 
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
	
	WHERE			EPI.TC_CodContexto = @L_TC_CodContexto 
					AND getdate() >= DATEADD(DAY, DATEDIFF(DAY, '19000101', EPI.TF_Fechainicio), '19000101')
					AND  getdate() <= DATEADD(DAY, DATEDIFF(DAY, '18991231', EPI.TF_FechaFinal ), '19000101')

	ORDER BY 		EPI.TF_FechaFinal DESC

END
GO
