SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:						<1.0>
-- Creado por:					<Henry Méndez Ch>
-- Fecha de creación:			<03/11/2020>
-- Descripción :				<Inserta un nuevo apremio para legajo> 
-- =================================================================================================================================================



CREATE PROCEDURE [Expediente].[PA_AgregarApremioLegajo]
	@CodigoApremio			uniqueidentifier,
	@CodLegajo				uniqueidentifier,
	@CodPuestoTrabajo		varchar(14),
	@CodContexto			varchar(4),
	@CodEntrega				varchar(12),
	@Descripcion			varchar(255),
	@FechaIngresoOficina	datetime2(2),
	@IDARCHIVO				uniqueidentifier,
	@FechaEnvio				datetime2(2),
	@EstadoApremio			char(1),
	@OrigenApremio			char(1),
	@UsuarioEntrega			varchar(30),
	@TramiteOrdenApremio	char(1)
	
AS
BEGIN
	
	DECLARE @L_CodigoApremio			uniqueidentifier	=	@CodigoApremio		 
	DECLARE @L_CodLegajo				uniqueidentifier	=	@CodLegajo			 
	DECLARE @L_CodPuestoTrabajo			varchar(14)			=	@CodPuestoTrabajo	 
	DECLARE @L_CodContexto				varchar(4)			=	@CodContexto		 
	DECLARE @L_CodEntrega				varchar(12)			=	@CodEntrega			 
	DECLARE @L_Descripcion				varchar(255)		=	@Descripcion		 
	DECLARE @L_FechaIngresoOficina		datetime2(2)		=	@FechaIngresoOficina 
	DECLARE @L_IDARCHIVO				uniqueidentifier	=	@IDARCHIVO			 
	DECLARE @L_FechaEnvio				datetime2(2)		=	@FechaEnvio			 
	DECLARE @L_EstadoApremio			char(1)				=	@EstadoApremio		 
	DECLARE @L_OrigenApremio			char(1)				=	@OrigenApremio		 
	DECLARE @L_UsuarioEntrega			varchar(30)			=	@UsuarioEntrega		 
	DECLARE @L_TramiteOrdenApremio		char(1)				=	@TramiteOrdenApremio
	
	INSERT INTO	Expediente.ApremioLegajo
				(TU_CodApremio
				,TU_CodLegajo
				,TC_CodPuestoTrabajo
				,TC_CodContexto
				,TC_CodEntrega
				,TC_Descripcion
				,TF_FechaIngresoOficina
				,TC_IDARCHIVO
				,TF_FechaEnvio
				,TC_EstadoApremio
				,TC_OrigenApremio
				,TC_UsuarioEntrega
				,TC_TramiteOrdenApremio
				,TF_FechaEstado)
	VALUES
				(@L_CodigoApremio			
				,@L_CodLegajo					
				,@L_CodPuestoTrabajo				
				,@L_CodContexto				
				,@L_CodEntrega				
				,@L_Descripcion				
				,@L_FechaIngresoOficina	
				,@L_IDARCHIVO			
				,@L_FechaEnvio				
				,@L_EstadoApremio			
				,@L_OrigenApremio			
				,@L_UsuarioEntrega		
				,@L_TramiteOrdenApremio	
				,GetDate())	
			   
	SELECT @L_CodigoApremio
END


GO
