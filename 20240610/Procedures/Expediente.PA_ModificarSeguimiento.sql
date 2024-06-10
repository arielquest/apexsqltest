SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Mario Camacho Flores>
-- Fecha de creación:		<15/06/2021>
-- Descripción :			<Permite modificar un seguimiento de acuerdo a una respuesta> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ModificarSeguimiento]
		@CodSeguimiento					UNIQUEIDENTIFIER,
		@Resultado						VARCHAR(15),
		@Observaciones					VARCHAR(255),
		@CodPuestoTrabajo				UNIQUEIDENTIFIER,
		@UsuarioRed						VARCHAR(30)
AS
BEGIN

DECLARE
		@L_CodSeguimiento			UNIQUEIDENTIFIER			=	@CodSeguimiento,
		@L_Resultado				VARCHAR(15)					=	@Resultado,	
		@L_Observaciones			VARCHAR(255)				=	@Observaciones,
		@L_CodPuestoTrabajo			UNIQUEIDENTIFIER			=	@CodPuestoTrabajo,
		@L_UsuarioRed				VARCHAR(30)					=	@UsuarioRed
	
	UPDATE	[Expediente].[Seguimiento]
	SET		TC_Resultado							=	@L_Resultado,		       
			TC_Obsercaciones						=	@L_Observaciones,		
			TU_CodPuestoTrabajoUsuarioActualiza		=	@L_CodPuestoTrabajo,		
			TC_UsuarioRedActualiza					=	@L_UsuarioRed,			
			TF_FechaActualizacion					=	GETDATE(),			
			TN_Estado								=	0
	WHERE	TU_CodSeguimiento						=	@L_CodSeguimiento
END
GO
