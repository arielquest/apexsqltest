SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<06/11/2018>
-- Descripción :			<Permite agregar un registro al historico de solicitud desacumulación> 
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <09/08/2019> <Se elimina el campo TN_CodEstado> 
-- Modificación				<Jonathan Aguilar Navarro> <23/08/2019> <Se agrega el contexto> 
-- Modificación				<Jonathan Aguilar Navarro> <23/10/2019> <Se agrega el tipo de desacumulación> 
-- Modificación				<Daniel Ruiz Hernández>	   <18/12/2020> <Se agrega el codigo de la fase.> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarSolicitudDesAcumulacion]
	@CodSolicitud				uniqueidentifier,
	@EstadoSolicitud			char(1),
	@CodigoFase					smallint,
	@NumeroExpediente			varchar(14),
	@UsuarioRed					varchar(30),
	@FechaSolicitud				datetime2,
	@FechaActualizacion			datetime2,
	@PuestoTrabajoAsignado		varchar(14),
	@AsignadoPor				varchar(14),
	@CodContexto				varchar(4),
	@TipoDesacumulacion			char(1)

AS  
BEGIN  
	INSERT INTO	Historico.SolicitudDesacumulacion
	(
		TU_CodSolicitud,
		TC_Estado,
		TN_CodFase,
		TC_NumeroExpediente,
		TC_UsuarioRed,
		TF_FechaSolicitud,
		TF_Actualizacion,
		TC_CodPuestoTrabajo,
		TC_AsignadoPor,
		TC_CodContexto,
		TC_TipoDesacumulacion
	)
	VALUES
	(
		@CodSolicitud,				
		@EstadoSolicitud,
		@CodigoFase,
		@NumeroExpediente,			
		@UsuarioRed,					
		@FechaSolicitud,				
		@FechaActualizacion,					
		@PuestoTrabajoAsignado,		
		@AsignadoPor,
		@CodContexto,
		@TipoDesacumulacion		
	)
END
GO
