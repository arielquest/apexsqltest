SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=============================================================================================================================================
-- Autor:		   <Jeffry Hernández>
-- Fecha Creación: <02/07/2018>
-- Descripcion:	   <Agrega un registro a la tabla Agenda.SolicitudSalaJuicio>
--=============================================================================================================================================
CREATE PROCEDURE  [Agenda].[PA_AgregarSolicitudSalaJuicio]  
	@CodSolicitud		uniqueidentifier,
	@CodEvento			uniqueidentifier,
	@CantidadPersonas	smallint,
	@FechaSolicitud		DateTime2,
	@ResultadoSolicitud	char(1),
	@FechaResultado		DateTime2,
	@Observaciones		varchar(150)
As
Begin

	INSERT INTO Agenda.SolicitudSalaJuicio		
	(
		TU_CodSolicitud,		TU_CodEvento,		TN_CantidadPersonas ,	TF_FechaSolicitud,
		TC_ResultadoSolicitud,	TF_FechaResultado,	TC_Observaciones
	)
	VALUES
	(
		NEWID(),				@CodEvento,			@CantidadPersonas,		@FechaSolicitud,
		@ResultadoSolicitud,	@FechaResultado,	@Observaciones
	)
	
End





GO
