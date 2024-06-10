SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<12/09/2017>
-- Descripción:				<Consulta si existe un acta de comunicacion para una comunicacion judicial> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarExisteActaComunicacion]
(
	@CodigoComunicacion VARCHAR(65)
)
AS
BEGIN

	Select	CASE 
			WHEN COUNT(*) > 0 THEN 1
			ELSE 0
		END As ExisteActa
	From	Comunicacion.ArchivoComunicacion	WITH(NOLOCK)
	Where	TU_CodComunicacion					=	@CodigoComunicacion
	And		TB_EsActa							=	1

END
GO
