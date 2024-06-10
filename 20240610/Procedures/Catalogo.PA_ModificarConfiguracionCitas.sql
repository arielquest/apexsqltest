SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <06/10/2020>  
-- Descripcion:     <Permite actualizar un registro de configuracion de citas>  
-- ==================================================================================================================================================================================  
-- Modificación:	<Xinia Soto V. 22/02/2020>
--					<Se agrega parametro de HabilitarFinSemana>
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ModificarConfiguracionCitas] 
 @CodConfiguracion   UNIQUEIDENTIFIER, 
 @CodContexto        VARCHAR(4),  
 @HoraInicio         TIME(7),
 @HoraFin            TIME(7),
 @HoraInicioAlmuerzo TIME(7),
 @TiempoAtencion     SMALLINT,
 @FechaInicio		 DATETIME2(7),
 @FechaFin		     DATETIME2(7),
 @HabilitaFinSemana	 BIT
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion, 
 @L_CodContexto              VARCHAR(4)       = @CodContexto,  
 @L_HoraInicio               TIME(7)          = @HoraInicio,
 @L_HoraFin                  TIME(7)          = @HoraFin,
 @L_HoraInicioAlmuerzo       TIME(7)          = @HoraInicioAlmuerzo,
 @L_TiempoAtencion           SMALLINT         = @TiempoAtencion, 
 @L_FechaInicio              DATETIME2(7)     = @Fechainicio,
 @L_FechaFin                 DATETIME2(7)     = @FechaFin,
 @L_HabilitaFinSemana        BIT              = @HabilitaFinSemana
 --Lógica  
 UPDATE Catalogo.ConfiguracionCita WITH (ROWLOCK)  
 SET  TF_HoraInicio         = @L_HoraInicio,  
      TF_HoraFin            = @L_HoraFin,  
      TF_HoraInicioAlmuerzo = @L_HoraInicioAlmuerzo,  
      TN_TiempoAtencion     = @L_TiempoAtencion,
	  TF_FechaInicio	    = @L_FechaInicio,
	  TF_FechaFinal         = @L_FechaFin,
	  TB_HabilitaFinSemana  = @L_HabilitaFinSemana
 WHERE TU_CodConfiguracion  = @L_CodConfiguracion
 AND  TC_CodContexto        = @L_CodContexto  



END
GO
