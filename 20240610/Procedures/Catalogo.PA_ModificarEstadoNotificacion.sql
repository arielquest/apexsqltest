SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================
--  OBJETO      : PA_ModificarEstadoNotificacion
--  DESCRIPCION : Permitir actualizar registro en la tabla de Estado Notificacion                   
--  VERSION     : 1.0           
--  CREACION    : 10/05/2016
--  AUTOR       : Donald Vargas Zùñiga
-- ===============================================================================
  
 CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoNotificacion]
 @CodEstadoNotificacion  tinyint,
 @Descripcion varchar(50),
 @FinVigencia datetime2(7)
 As
 Begin
 
   UPDATE Catalogo.EstadoNotificacion
   SET		TC_Descripcion = @Descripcion,
			TF_Fin_Vigencia = @FinVigencia
   WHERE TN_CodEstadoNotificacion = @CodEstadoNotificacion
 End 


GO
