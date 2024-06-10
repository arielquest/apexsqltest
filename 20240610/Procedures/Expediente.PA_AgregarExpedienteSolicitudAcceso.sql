SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<20/09/2019>
-- Descripción :			<Permite agregar un registro de solicitud a la tabla Expediente.ExpedienteSolicitudAcceso> 
-- ===========================================================================================================================================================
-- Modificación:			<Aida Elena Siles Rojas> <25/08/2020> <Se agregan parámetros para registrar solicitud al momento de recibir itineración>
-- ===========================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarExpedienteSolicitudAcceso] 
     @Codigo								UNIQUEIDENTIFIER,
     @CodLegajo								UNIQUEIDENTIFIER,
	 @Descripcion							VARCHAR(225),
	 @CodContextoSolicitud					VARCHAR(4),
	 @CodPuestoTabajoFuncionarioSolicitud	UNIQUEIDENTIFIER,
	 @FechaSolicitud						DATETIME2,
	 @EstadoSolicitudAccesoExpediente		CHAR(1),
	 @CodContextoRevision					VARCHAR(4) = NULL,
	 @CodPuestoTrabajoFuncionarioRevision	UNIQUEIDENTIFIER = NULL,
	 @FechaRevision							DATETIME2 = NULL
AS  
BEGIN

DECLARE		@L_Codigo								UNIQUEIDENTIFIER = @Codigo
DECLARE		@L_CodLegajo							UNIQUEIDENTIFIER = @CodLegajo
DECLARE		@L_Descripcion							VARCHAR(225)	 = @Descripcion
DECLARE		@L_CodContextoSolicitud                 VARCHAR(4)		 = @CodContextoSolicitud
DECLARE		@L_CodPuestoTabajoFuncionarioSolicitud	UNIQUEIDENTIFIER = @CodPuestoTabajoFuncionarioSolicitud
DECLARE		@L_FechaSolicitud						DATETIME2		 = @FechaSolicitud
DECLARE		@L_EstadoSolicitudAccesoExpediente		CHAR(1)			 = @EstadoSolicitudAccesoExpediente
DECLARE		@L_CodContextoRevision					VARCHAR(4)		 = @CodContextoRevision
DECLARE		@L_CodPuestoTrabajoFuncionarioRevision	UNIQUEIDENTIFIER = @CodPuestoTrabajoFuncionarioRevision
DECLARE		@L_FechaRevision						DATETIME2        = @FechaRevision
  
  	INSERT INTO Expediente.ExpedienteSolicitudAcceso WITH (ROWLOCK)
			(	
				TU_CodSolicitudAccesoExpediente,		TU_CodLegajo,		TC_Descripcion,						TC_CodContextoSolicitud,	
				TU_CodPuestoFuncionarioSolicitud,		TF_Solicitud,		TC_EstadoSolicitudAccesoExpediente,	TC_CodContextoRevision,
				TU_CodPuestoFuncionarioRevision,		TF_Revision
			) 	
	VALUES	(	@L_Codigo,								@L_CodLegajo,		@L_Descripcion,						@L_CodContextoSolicitud,		
				@L_CodPuestoTabajoFuncionarioSolicitud,	@L_FechaSolicitud,	@L_EstadoSolicitudAccesoExpediente,	@L_CodContextoRevision,
				@L_CodPuestoTrabajoFuncionarioRevision,	@L_FechaRevision
			)
END
GO
