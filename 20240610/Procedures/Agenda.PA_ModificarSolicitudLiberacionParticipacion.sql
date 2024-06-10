SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=============================================================================================================================================
-- Autor:		   <Diego Navarrete>
-- Fecha Creación: <04/04/2018>
-- Descripcion:	   <Modifica un registro de la tabla Agenda.SolicitudLiberacionParticipacion>
--=============================================================================================================================================
CREATE PROCEDURE  [Agenda].[PA_ModificarSolicitudLiberacionParticipacion]  
	@CodigoSolicitudLiberacion uniqueidentifier,
	@DescripcionSolicitud	varchar(200),
	@FechaInicioLiberacion	DateTime2,
	@FechaFinLiberacion		DateTime2,
	@Observaciones			varchar(200),
	@FechaResultado			DateTime2,
	@Aprobada				BIT
As
Begin

	UPDATE	Agenda.SolicitudLiberacionParticipacion	

	SET		TC_DescripcionSolicitud		=	@DescripcionSolicitud,
			TF_FechaInicioLiberacion	=	@FechaInicioLiberacion,
			TF_FechaFinLiberacion		=	@FechaFinLiberacion,			
			TC_Observaciones			=	@Observaciones,		
			TB_Aprobada					=	@Aprobada,
			TF_FechaResultado			=	@FechaResultado

	WHERE 	TU_CodSolicitudLiberacion	=	@CodigoSolicitudLiberacion
	
End
GO
