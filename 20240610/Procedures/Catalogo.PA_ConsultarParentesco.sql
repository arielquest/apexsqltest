SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
  
  
-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Gerardo  Lopez>  
-- Fecha de creación:  <03/05/2016>  
-- Descripción :   <Permite Consultar los tipos de parentesco>   
 --  
-- Modificación:   <08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>  
-- Modificación:   <10/09/2020> <Xinia Soto V.> <Se para que retorne correctamente los activos.>  
-- =================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarParentesco]  
 @Codigo     smallint = Null,  
 @Descripcion  Varchar(50)  = Null,  
 @TipoParentesco      char(1)         = null,  
 @FechaActivacion datetime2(3) = Null,  
 @FechaDesactivacion Datetime2  = Null  
  
 As  
 Begin  
    
 --Variable para almacenar la descripcion   
 Declare @ExpresionLike Varchar(200)  
 Set  @ExpresionLike = iif(@Descripcion Is Not Null,'%' +  @Descripcion + '%','%')  
   
 --Si todo es nulo se devuelven todos los registros  
 If @FechaActivacion Is Null And @FechaDesactivacion Is Null And @Descripcion Is Null And @Codigo Is Null  
 Begin   
   Select  TC_CodParentesco  As Codigo,    TC_Descripcion As Descripcion,  
      TN_Nivel as Nivel,   
      TF_Inicio_Vigencia As FechaActivacion, TF_Fin_Vigencia As FechaDesactivacion  
      , TC_TipoParentesco as Tipo  
   From  Catalogo.Parentesco  With(NoLock)  
   Where  TC_Descripcion like @ExpresionLike  
   -- and TC_TipoParentesco =@TipoParentesco  
   Order By TC_Descripcion;  
 End  
   
 --Solo por codigo  
 Else IF @Codigo Is Not Null  
 Begin  
   Select  TC_CodParentesco  As Codigo,    TC_Descripcion As Descripcion,  
      TN_Nivel as Nivel,    
      TF_Inicio_Vigencia As FechaActivacion, TF_Fin_Vigencia As FechaDesactivacion  
      , TC_TipoParentesco as Tipo  
   From  Catalogo.Parentesco  
   Where  TC_CodParentesco = @Codigo  
   Order By TC_Descripcion;  
 End   
   
 --Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion  
 Else If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null  
 Begin  
   Select  TC_CodParentesco  As Codigo,    TC_Descripcion As Descripcion,  
      TN_Nivel as Nivel,    
      TF_Inicio_Vigencia As FechaActivacion, TF_Fin_Vigencia As FechaDesactivacion  
      , TC_TipoParentesco as Tipo  
   From  Catalogo.Parentesco  
   where  TC_Descripcion like @ExpresionLike  
  -- and TC_TipoParentesco =@TipoParentesco  
   And   TF_Inicio_Vigencia  < GETDATE ()  
   And   ( TF_Fin_Vigencia  Is Null   
      OR TF_Fin_Vigencia  >= GETDATE ())  
   Order By TC_Descripcion;  
 End  
 Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null  
 Begin  
  Select  TC_CodParentesco  As Codigo,    TC_Descripcion As Descripcion,  
     TN_Nivel as Nivel,     
     TF_Inicio_Vigencia As FechaActivacion, TF_Fin_Vigencia As FechaDesactivacion  
     , TC_TipoParentesco as Tipo  
  From  Catalogo.Parentesco  
  where  TC_Descripcion like @ExpresionLike  
  --and TC_TipoParentesco =@TipoParentesco  
  And   ( TF_Inicio_Vigencia  > GETDATE ()  
     Or TF_Fin_Vigencia  < GETDATE ())  
  Order By TC_Descripcion;  
 End  
 Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null  
 Begin  
  Select  TC_CodParentesco  As Codigo,    TC_Descripcion As Descripcion,  
     TN_Nivel as Nivel,     
     TF_Inicio_Vigencia As FechaActivacion, TF_Fin_Vigencia As FechaDesactivacion  
     , TC_TipoParentesco as Tipo  
  From  Catalogo.Parentesco  
  where  TC_Descripcion like @ExpresionLike  
  --and TC_TipoParentesco =@TipoParentesco  
  And   TF_Inicio_Vigencia >= @FechaActivacion  
  And   TF_Fin_Vigencia  <= @FechaDesactivacion  
  Order By TC_Descripcion;  
 End  
 End  
  
  
GO
