SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<30/10/2020>
-- Descripción :			<Permite desasociar un una tarea a un contexto y tipo de puesto de trabajo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarTareaContextoTipoPuestoTrabajo]
	@CodContexto			varchar(4),
	@CodTipoPuestoTrabajo	smallint,
	@CodTarea				smallint
AS 
BEGIN

	DECLARE	
	@L_TC_CodContexto				varchar(4)				=	@CodContexto,
	@L_TN_CodTipoPuestoTrabajo		smallint				=	@CodTipoPuestoTrabajo,
	@L_TN_CodTarea					smallint				=	@CodTarea
	


	DELETE 
	FROM	Catalogo.TareaContextoTipoPuestoTrabajo
	WHERE	TC_CodContexto									=	@L_TC_CodContexto
	AND		TN_CodTipoPuestoTrabajo							=	@L_TN_CodTipoPuestoTrabajo
	AND		TN_CodTarea										=	@L_TN_CodTarea
	
END

GO
