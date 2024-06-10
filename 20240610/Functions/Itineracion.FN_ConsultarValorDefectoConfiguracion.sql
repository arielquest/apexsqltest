SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Karol Jiménez Sánchez>
-- Fecha de creación:		<08-01-2020>
-- Descripción :			<Obtiene el valor de configuración vigente para el despacho correspondiente, o el valor general> 
-- =================================================================================================================================================
CREATE FUNCTION [Itineracion].[FN_ConsultarValorDefectoConfiguracion]
(
	@CodConfiguracion		Varchar(27),
	@CodContexto			Varchar(4) 
)
RETURNS Varchar(255)
AS
BEGIN

	Declare	@Resultado As VARCHAR(255);

	SELECT		TOP 1 @Resultado	=	
				CASE WHEN C.TB_EsValorGeneral = 0 THEN CVD.TC_Valor
					ELSE
						CV.TC_Valor
				END
	FROM		Configuracion.Configuracion			C	WITH(NOLOCK)
	LEFT JOIN	Configuracion.ConfiguracionValor	CVD	WITH(NOLOCK)
	ON			CVD.TC_CodConfiguracion				=	C.TC_CodConfiguracion
	AND			CVD.TF_FechaActivacion				<=	GETDATE()
	AND			(CVD.TF_FechaCaducidad				>=	GETDATE() 
					OR CVD.TF_FechaCaducidad		IS	NULL)
	AND			CVD.TC_CodContexto					=	@CodContexto
	LEFT JOIN	Configuracion.ConfiguracionValor	CV	WITH(NOLOCK)
	ON			CV.TC_CodConfiguracion				=	C.TC_CodConfiguracion
	AND			CV.TF_FechaActivacion				<=	GETDATE()
	AND			(CV.TF_FechaCaducidad				>=	GETDATE() 
					OR CV.TF_FechaCaducidad			IS	NULL)
	WHERE		(CVD.TC_CodConfiguracion			IS NULL 
					OR CVD.TC_CodConfiguracion		=	@CodConfiguracion)
	And			CV.TC_CodConfiguracion				=	@CodConfiguracion
	
	Return @Resultado;
END
GO
