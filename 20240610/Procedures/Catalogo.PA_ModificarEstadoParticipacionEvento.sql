SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<09/09/2016>
-- Descripción:				<Permite modificar un estado del participante del evento.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoParticipacionEvento] 
	@CodEstadoParticipacion		int				= Null,
	@Descripcion				varchar(150)	= Null,			
	@FechaDesactivacion			datetime2		= Null
AS
BEGIN
	UPDATE	Catalogo.EstadoParticipacionEvento
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaDesactivacion
	WHERE	TN_CodEstadoParticipacion	=	@CodEstadoParticipacion;
END
GO
