SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================  
-- Autor:           <Xinia Soto V>
-- Fecha Creación:  <12/10/2020>  
-- Descripcion:     <Permite ingresar un registro para desactivar un horario de atención de citas de GL>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Configuracion].[PA_AgregarHorarioCitaHabilitado] 
 @CodConfiguracion  UNIQUEIDENTIFIER, 
 @HabilitaLunes	    BIT,
 @HabilitaMartes    BIT,
 @HabilitaMiercoles BIT,
 @HabilitaJueves	BIT,
 @HabilitaViernes	BIT,
 @HabilitaSabado	BIT,
 @HabilitaDomingo	BIT,
 @HoraInicio	    TIME(7)
 AS  
BEGIN  
 --Variables  
 DECLARE 
 @L_CodConfiguracion  UNIQUEIDENTIFIER = @CodConfiguracion, 
 @L_HabilitaLunes     BIT			   = @HabilitaLunes,
 @L_HabilitaMartes    BIT              = @HabilitaMartes,  
 @L_HabilitaMiercoles BIT              = @HabilitaMiercoles,  
 @L_HabilitaJueves    BIT              = @HabilitaJueves,  
 @L_HabilitaViernes   BIT              = @HabilitaViernes, 
 @L_HabilitaSabado    BIT              = @HabilitaSabado,  
 @L_HabilitaDomingo   BIT              = @HabilitaDomingo,  
 @L_HoraInicio        TIME(7)          = @HoraInicio  

 --Lógica  
 INSERT INTO Configuracion.HorarioCitaHabilitado VALUES(NEWID() ,@L_CodConfiguracion, @L_HoraInicio,@L_HabilitaLunes,@L_HabilitaMartes,@L_HabilitaMiercoles,@L_HabilitaJueves,@L_HabilitaViernes, @L_HabilitaSabado, @L_HabilitaDomingo)

 END
GO
