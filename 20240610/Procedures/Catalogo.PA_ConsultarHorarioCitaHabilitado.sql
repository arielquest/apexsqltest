SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <12/10/2020>  
-- Descripcion:     <Permite obtener los horarios deshabilitados para la atención de citas de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarHorarioCitaHabilitado] 
 @CodConfiguracion UNIQUEIDENTIFIER
 AS  
BEGIN  
 --Variables  
 DECLARE @L_CodConfiguracion UNIQUEIDENTIFIER = @CodConfiguracion

 --Lógica  
Select TU_CodHorario, 
	TU_CodConfiguracion as 'CodConfiguracion',
	TF_HoraInicio       as 'HoraInicio', 
	TB_Lunes            as 'HabilitaLunes', 
	TB_Martes           as 'HabilitaMartes',
	TB_Miercoles        as 'HabilitaMiercoles', 
	TB_Jueves           as 'HabilitaJueves', 
	TB_Viernes          as 'HabilitaViernes',
	TB_Sabado           as 'HabilitaSabado',
	TB_Domingo          as 'HabilitaDomingo'
From Catalogo.HorarioCitaHabilitado 
WHERE TU_CodConfiguracion = @L_CodConfiguracion
ORDER BY TF_HoraInicio ASC

 END
GO
