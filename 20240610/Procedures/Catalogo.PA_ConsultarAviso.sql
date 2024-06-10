SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Xinia Soto Valerio.>  
-- Fecha de creación:  <24/01/2020>  
-- Descripción:    <Permite consultar el catálogo de avisos>  
-- ===========================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarAviso]  
 @CodAviso  bigint,  
 @Sistema  varchar(1),  
 @Descripcion varchar(255),  
 @FechaInicio datetime2 = Null,  
 @FechaFin    datetime2 = Null  
As    
BEGIN    
   
--Variables.  
Declare @L_TC_Descripcion VarChar(255) = @Descripcion,  
  @L_TC_Sistema   Varchar(1)   = @Sistema,  
  @L_TF_FecInicio   DateTime2    = @FechaInicio,  
  @L_TF_FecFin   DateTime2    = @FechaFin,  
  @L_TN_CodAviso   BigInt    = @CodAviso  
  
--Lógica.  
  
 --Todos  
 If @L_TF_FecFin Is Null And @L_TF_FecInicio Is Null --Todos    
 Begin  
   SELECT  TN_CodAviso    AS 'Codigo',   
   TC_Descripcion AS 'Descripcion',   
   TF_FecInicio   AS 'FechaInicio',   
   TF_FecFin      AS 'FechaFin',   
   convert(time(0),TF_FecInicio) AS 'HoraInicio',   
   convert(time(0),TF_FecFin)    AS 'HoraFin',  
   'split'        As Split,  
   TC_Sistema     AS 'Sistema'   
   FROM Catalogo.Aviso WITH (NOLOCK)  
   WHERE TN_CodAviso = (case @L_TN_CodAviso when 0 then TN_CodAviso else @L_TN_CodAviso end) AND  
      TC_Sistema  = (case @L_TC_Sistema when ' ' then TC_Sistema else @L_TC_Sistema end) AND  
      TC_Descripcion like  + '%'+ ISNULL(@L_TC_Descripcion, TC_Descripcion) + '%'   
  ORDER BY TF_FecInicio DESC  
 End    
 --Activos  
 Else If  @L_TF_FecFin is null and @L_TF_FecInicio Is Not Null  
 Begin  
  SELECT  TN_CodAviso    AS 'Codigo',   
   TC_Descripcion AS 'Descripcion',   
   TF_FecInicio   AS 'FechaInicio',   
   TF_FecFin    AS 'FechaFin',   
   convert(time(0),TF_FecInicio) AS 'HoraInicio',   
   convert(time(0),TF_FecFin)    AS 'HoraFin',  
   'split'        As Split,  
   TC_Sistema     AS 'Sistema'   
   FROM Catalogo.Aviso WITH (NOLOCK)  
   WHERE TN_CodAviso = (case @L_TN_CodAviso when 0 then TN_CodAviso else @L_TN_CodAviso end) AND  
      TC_Sistema  = (case @L_TC_Sistema when ' ' then TC_Sistema else @L_TC_Sistema end) AND  
      TC_Descripcion like  + '%'+ ISNULL(@L_TC_Descripcion, TC_Descripcion) + '%'   
     And   TF_FecInicio     <= GETDATE ()    
     And   (TF_FecFin      Is Null Or TF_FecFin >= GETDATE ())   
    ORDER BY TF_FecInicio DESC  
 End  
 --Inactivos  
 Else  If @L_TF_FecFin Is Not Null And @L_TF_FecInicio Is Null  
  Begin  
   SELECT  TN_CodAviso    AS 'Codigo',   
   TC_Descripcion AS 'Descripcion',   
   TF_FecInicio   AS 'FechaInicio',   
   TF_FecFin    AS 'FechaFin',   
   convert(time(0),TF_FecInicio) AS 'HoraInicio',   
   convert(time(0),TF_FecFin)    AS 'HoraFin',  
   'split'        As Split,  
   TC_Sistema     AS 'Sistema'   
   FROM Catalogo.Aviso WITH (NOLOCK)  
   WHERE TN_CodAviso = (case @L_TN_CodAviso when 0 then TN_CodAviso else @L_TN_CodAviso end) AND  
      TC_Sistema  = (case @L_TC_Sistema when ' ' then TC_Sistema else @L_TC_Sistema end) AND  
      TC_Descripcion like  + '%'+ ISNULL(@L_TC_Descripcion, TC_Descripcion) + '%'   
     And   (TF_FecInicio     > GETDATE () Or TF_FecFin < GETDATE ())    
    ORDER BY TF_FecInicio DESC  
 End  
   
  
END     
GO
