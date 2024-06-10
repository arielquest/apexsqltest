SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Autor:				<Gerardo Lopez>
-- Fecha Creación:		<28/10//2015>
-- Descripcion:			<Modificar fecha vigencia de un asignado del expediente >
-- Modificado por:		<25/03/2019> <Isaac Dobles> <Se ajusta para tabla Historico.ExpedienteAsignado.>
-- =================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto> <Se agrega parametor de ESRESPONSABLE para modificación>
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ModificarExpedienteAsignado] 
	@NumeroExpediente			CHAR(14),
	@CodPuestoTrabajo			VARCHAR(14), 	 
	@FechaVencimiento			DATETIME2,
	@EsResponsable				BIT
AS

BEGIN
	 DECLARE		@L_NumeroExpediente			CHAR(14)		=	@NumeroExpediente,
					@L_CodPuestoTrabajo			VARCHAR(14)		=	@CodPuestoTrabajo,
					@L_FechaVencimiento			DATETIME2		=	@FechaVencimiento,
					@L_EsResponsable			BIT				=	@EsResponsable


  	 UPDATE			Historico.ExpedienteAsignado 
	 SET			TF_Fin_Vigencia								=	@L_FechaVencimiento,
					TB_EsResponsable							=   @L_EsResponsable
	 WHERE			TC_NumeroExpediente							=	@L_NumeroExpediente
	 AND			TC_CodPuestoTrabajo							=	@L_CodPuestoTrabajo
 
END

GO
