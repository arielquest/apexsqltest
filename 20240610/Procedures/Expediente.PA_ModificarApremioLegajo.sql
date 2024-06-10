SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================  
-- Versión:			<1.0>  
-- Creado por:		<Henry Méndez Ch>  
-- Fecha creación:	<23/10/2020>  
-- Descripción :	<Permite modificar un apremio de un legajo>   
-- =================================================================================================================================================  

CREATE PROCEDURE [Expediente].[PA_ModificarApremioLegajo]  
  @CodApremio			Uniqueidentifier,  
  @CodPuestoTrabajo		varchar(14)		=	null,  
  @Descripcion			varchar(255)	=	null,   
  @EstadoApremio		char(1)			=	null
  
AS  
BEGIN  
 --Declaracion de variables para el proceso  
 DECLARE @L_CodApremio			Uniqueidentifier	=	@CodApremio
 DECLARE @L_CodPuestoTrabajo	varchar(14)			=	@CodPuestoTrabajo   
 DECLARE @L_Descripcion			varchar(255)		=	@Descripcion 
 DECLARE @L_EstadoApremio		char(1)				=	@EstadoApremio 
 DECLARE @L_FechaEstado			datetime2			=	null

	--Si el estado no es nulo se actualiza la fecha
	IF		@L_EstadoApremio	Is Not Null
	BEGIN		
		SELECT @L_FechaEstado	=	GetDate()
	END
  
	UPDATE	[Expediente].[ApremioLegajo]  
    SET		TC_CodPuestoTrabajo		=	COALESCE(@L_CodPuestoTrabajo, TC_CodPuestoTrabajo),  
			TC_Descripcion			=	COALESCE(@L_Descripcion,	TC_Descripcion),
			TC_EstadoApremio		=	COALESCE(@L_EstadoApremio,	TC_EstadoApremio),
			TF_FechaEstado			=	COALESCE(@L_FechaEstado,	TF_FechaEstado)		
  WHERE		TU_CodApremio			=	@L_CodApremio  
END  
GO
