SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=============================================================================================================================================
-- Autor:		   <Diego Navarrete>
-- Fecha Creación: <04/04/2018>
-- Descripcion:	   <Agrega un registro a la tabla Agenda.SolicitudLiberacionParticipacion>
--=============================================================================================================================================
CREATE PROCEDURE  [Agenda].[PA_AgregarSolicitudLiberacionParticipacion]  
	@CodParticipacion		uniqueidentifier,
	@DescripcionSolicitud	varchar(200),
	@FechaInicioLiberacion	DateTime2,
	@FechaFinLiberacion		DateTime2,
	@Observaciones			varchar(200)
As
Begin

	INSERT INTO Agenda.SolicitudLiberacionParticipacion		
	(
		TU_CodSolicitudLiberacion,	TU_CodParticipacion,	TC_DescripcionSolicitud,	TF_FechaInicioLiberacion,
		TF_FechaFinLiberacion,		TC_Observaciones,		TB_Aprobada,		        TF_FechaSolicitud,
		TF_FechaResultado
	)
	VALUES
	(
		NEWID(),						@CodParticipacion,		@DescripcionSolicitud,		@FechaInicioLiberacion,
		@FechaFinLiberacion,			@Observaciones,			NULL,						GETDATE(),
		NULL
	)
	
End





GO
