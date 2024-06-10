SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<09/09/2016>
-- Descripción:				<Permite agregar un estado del participante del evento.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoParticipacionEvento]
   @Descripcion			varchar(150)	= Null,
   @FechaActivacion		datetime2		= Null,
   @FechaDesactivacion	datetime2		= Null
AS 
BEGIN
	INSERT INTO Catalogo.EstadoParticipacionEvento
		(TC_Descripcion,
		TF_Inicio_Vigencia,
		TF_Fin_Vigencia)
	VALUES
		(@Descripcion,
		@FechaActivacion,
		@FechaDesactivacion);
END;
GO
