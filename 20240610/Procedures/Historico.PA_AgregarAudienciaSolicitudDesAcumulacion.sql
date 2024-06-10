SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<09/10/2018>
-- Descripción :			<Permite agregar un registro al historico de AudienciaSolicitudDesAcumulación> 
-- =================================================================================================================================================

CREATE Procedure [Historico].[PA_AgregarAudienciaSolicitudDesAcumulacion]
	@CodSolicitud				uniqueidentifier,
	@CodAudiencia				bigint,
	@ModoSeleccion				char(1)

AS  
begin  
	
	Declare @L_CodSolicitud		uniqueidentifier	= @CodSolicitud
	Declare @L_CodAudiencia		bigint				= @CodAudiencia
	Declare @L_ModoSeleccion	char(1)				= @ModoSeleccion

	insert into	Historico.AudienciaSolicitudDesacumulacion
	(
		TU_CodSolicitud,
		TN_CodAudiencia,
		TC_ModoSeleccion
	)
	values
	(
		@L_CodSolicitud,					
		@L_CodAudiencia,			
		@L_ModoSeleccion						
	)
end
GO
