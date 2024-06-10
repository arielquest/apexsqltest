SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <12/10/2020>  
-- Descripcion:     <Permite obtener la configuración para la atención de citas de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarConfiguracionCita]
 @CodContexto Varchar(4)
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodContexto Varchar(4) = @CodContexto

 --Lógica  
Select  
	 J.TU_CodConfiguracion as Codigo,
	 J.TF_HoraInicio as HoraInicio,
	 J.TF_HoraFin as HoraFin,
	 J.TF_HoraInicioAlmuerzo as HoraInicioAlmuerzo,
	 J.TN_TiempoAtencion as TiempoAtencion,
	 J.TF_FechaInicio as FechaInicio,
	 J.TF_FechaFinal as FechaFin,
	 J.TB_HabilitaFinSemana as 'HabilitaFinSemana'
From Catalogo.ConfiguracionCita J
WHERE TC_CodContexto= @L_CodContexto


 END
GO
