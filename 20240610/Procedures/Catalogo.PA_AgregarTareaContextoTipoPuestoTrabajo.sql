SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<29/10/2020>
-- Descripción :			<Permite asociar una tarea a un contexto y un tipo de puesto de trabajo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTareaContextoTipoPuestoTrabajo]
	@CodContexto			varchar(4),
	@CodTipoPuestoTrabajo	smallint,
	@CodTarea				smallint
AS 
BEGIN

	DECLARE	
	@L_TC_CodContexto					varchar(4)		=	@CodContexto,
	@L_TN_CodTipoPuestoTrabajo			smallint		=	@CodTipoPuestoTrabajo,
	@L_TN_CodTarea						smallint		=	@CodTarea


	INSERT INTO Catalogo.TareaContextoTipoPuestoTrabajo
	(	
		TC_CodContexto,	
		TN_CodTipoPuestoTrabajo,		
		TN_CodTarea,	
		TF_Inicio_Vigencia
	)
	VALUES
	(	
		@L_TC_CodContexto,	
		@L_TN_CodTipoPuestoTrabajo,		
		@L_TN_CodTarea,		
		GETDATE()
	)
END

GO
