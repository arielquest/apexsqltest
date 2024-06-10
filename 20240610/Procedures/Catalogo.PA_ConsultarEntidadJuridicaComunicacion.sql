SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:				Jose Gabriel Cordero Soto
-- Create date:			19/01/2022
-- Description:			Consultar Entidad juridica asociada a una comunicación por lo menos
-- =============================================
-- Modificado por:		<27/01/2022><Jorge Isaac Dobles><Se aplica cambio con respecto a un cambio con la identificación en el resultado de la consulta>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEntidadJuridicaComunicacion]
--ALTER PROCEDURE [Catalogo].[PA_ConsultarEntidadJuridicaComunicacion]
	@Identificacion	VARCHAR(10)
AS
BEGIN
	DECLARE @L_Identificacion VARCHAR(10) = @Identificacion

    -- Insert statements for procedure here
	SELECT		TOP 1(B.TC_Identificacion)				Identificacion,
				A.TC_Descripcion						Descripcion,
				A.TC_Siglas								Siglas,
				A.TF_Inicio_Vigencia					FechaActivacion,
				A.TF_Fin_Vigencia						FechaDesactivacion

	FROM		Catalogo.EntidadJuridica				A WITH(NOLOCK)
	INNER JOIN	Persona.Persona							B WITH(NOLOCK)
	ON			A.TC_Identificacion						= B.TC_Identificacion
	INNER JOIN	Expediente.Intervencion					C WITH(NOLOCK)
	ON			B.TU_CodPersona							= C.TU_CodPersona
	INNER JOIN	Comunicacion.ComunicacionIntervencion	D WITH(NOLOCK)
	ON			C.TU_CodInterviniente					= D.TU_CodInterviniente

	WHERE		A.TC_Identificacion						= @L_Identificacion

	GROUP BY	B.TC_Identificacion,
				A.TC_Descripcion,
				A.TC_Siglas,
				A.TF_Inicio_Vigencia,
				A.TF_Fin_Vigencia
END
GO
