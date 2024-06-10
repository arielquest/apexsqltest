SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <06/10/2020>  
-- Descripcion:     <Permite insertar un registro de configuracion de citas>  
-- ==================================================================================================================================================================================  

CREATE PROCEDURE [Catalogo].[PA_AgregarConfiguracionCitas] 
 @CodContexto          VARCHAR(4),  
 @HoraInicio           TIME(7),
 @HoraFin              TIME(7),
 @HoraInicioAlmuerzo   TIME(7),
 @TiempoAtencion       SMALLINT,
 @FechaInicio		   DATETIME2(7),
 @FechaFin		       DATETIME2(7),
 @HabilitaFinSemana	   BIT,
 @CodConfiguracionCita UNIQUEIDENTIFIER
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodContexto      VARCHAR(4)       = @CodContexto,  
 @L_HoraInicio               TIME(7)          = @HoraInicio,
 @L_HoraFin                  TIME(7)          = @HoraFin,
 @L_HoraInicioAlmuerzo       TIME(7)          = @HoraInicioAlmuerzo,
 @L_TiempoAtencion           SMALLINT         = @TiempoAtencion, 
 @L_FechaInicio              DATETIME2(7)     = @Fechainicio,
 @L_FechaFin                 DATETIME2(7)     = @FechaFin,
 @L_CodConfiguracionCita	 UNIQUEIDENTIFIER = @CodConfiguracionCita,
 @L_HabilitaFinSemana        BIT			  = @HabilitaFinSemana
 --Lógica  


 Insert into Catalogo.ConfiguracionCita values(
	  @L_CodConfiguracionCita, 
	  @L_HoraInicio,  
      @L_HoraFin,  
      @L_HoraInicioAlmuerzo, 
	  @L_CodContexto,  
      @L_TiempoAtencion,
	  @L_FechaInicio,
	  @L_FechaFin,
	  @L_HabilitaFinSemana,
	  GETDATE())


END
GO
