SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ailyn López> 
-- Fecha de creación:		<02/05/2018>
-- Descripción:				<Consulta los valores de configuraciones generales vigentes en la fecha actual>
-- Modificación:			<Jeffry Hernández><17/07/2018><Se crea variable @FechaActual>
-- ===========================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarConfiguracionValorGeneral]
AS
BEGIN

					DECLARE @FechaActual DATETIME2 = Getdate()	

	SELECT 
					CV.TU_Codigo						As Codigo,						
					CV.TF_FechaCreacion					As FechaCreacion,				CV.TF_FechaActivacion			As FechaActivacion,
					CV.TF_FechaCaducidad				As FechaCaducidad,				CV.TC_Valor						As Valor,
					'SplitConfiguracion'				As SplitConfiguracion,  		C.TC_CodConfiguracion			AS Codigo	
						
	FROM			Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
	INNER JOIN		Configuracion.Configuracion			C  WITH(NOLOCK)
	on				C.TC_CodConfiguracion		=		CV.TC_CodConfiguracion
	WHERE			C.TB_EsValorGeneral			=		1  AND
					@FechaActual				>=		CV.TF_FechaActivacion AND
					(TF_FechaCaducidad			is		NULL 
					OR
					@FechaActual				<=		CV.TF_FechaCaducidad  
					)	
END
GO
