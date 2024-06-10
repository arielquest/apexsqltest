SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:   <1.0>  
-- Creado por:  <Jose Gabriel Cordero Soto>  
-- Fecha creación: <14/10/2019>  
-- Descripción : <Permite modificar el tipo de escrito y descripcion de una escrito de un expediente.>   
-- =================================================================================================================================================  
-- Modificacion:    <18/11/2019><Jose Gabriel Cordero Soto><Se realiza ajuste en modificar escrito del expediente agregando el estado del escrito y aplicando estandar correcto>  
-- Modificacion:    <26/11/2019><Jose Gabriel Cordero Soto><Se agrega en la modificación el valor del responsable (Puesto de trabajo)>  
-- Modificacion:    <26/05/2020><Xinia Soto V.><Se agrega en la modificación el valor de varias gestiones> 
-- Modificación:	<22/08/2020><Andrew Allen Dawson><Se Agrega la funcion COALESCE sobre los campos a ser actualizados>
-- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ModificarEscritoExpediente]  
  @CodEscrito Uniqueidentifier,  
  @CodTipoEscrito smallint = null,  
  @Descripcion varchar(255) = null,  
  @Responsable varchar(14) = null,  
  @EstadoEscrito char(1) = null,
  @VariasGestiones bit = null
AS  
BEGIN  
 --Declaracion de variables para el proceso  
 DECLARE @L_CodEscrito UniqueIdentifier = @CodEscrito  
 DECLARE @L_CodTipoEscrito smallint = @CodTipoEscrito  
 DECLARE @L_Descripcion varchar(255) = @Descripcion  
 DECLARE @L_PuestoTrabajo varchar(14) = @Responsable  
 DECLARE @L_EstadoEscrito char(1) = @EstadoEscrito  
 DECLARE @L_VariasGestiones bit = @VariasGestiones  
  
 --Ejecucion del proceso de modificación  
 UPDATE [Expediente].[EscritoExpediente]  
    SET TN_CodTipoEscrito = COALESCE(@L_CodTipoEscrito, TN_CodTipoEscrito),  
     TC_Descripcion = COALESCE(@L_Descripcion, TC_Descripcion),
     TC_EstadoEscrito = COALESCE(@L_EstadoEscrito, TC_EstadoEscrito),
     TC_CodPuestoTrabajo = COALESCE(@L_PuestoTrabajo, TC_CodPuestoTrabajo),
	 TB_VariasGestiones = COALESCE(@L_VariasGestiones, TB_VariasGestiones)
  WHERE [TU_CodEscrito] = @L_CodEscrito  
END  
GO
