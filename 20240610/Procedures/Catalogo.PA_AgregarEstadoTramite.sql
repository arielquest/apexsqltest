SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarEstadoTramite
**  DESCRIPCION : Permitir agregar registro en la tabla EstadoTramite                   
**  CREACION    : 19/02/2016 : Pablo Alvarez
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoTramite] 
 @Descripcion varchar(50),
 @InicioVigencia datetime2,
 @FinVigencia datetime2
 As
 Begin

   Insert into [Catalogo].[EstadoTramite] (TC_Descripcion   ,TF_Inicio_Vigencia   ,TF_Fin_Vigencia )
                           Values (@Descripcion ,@InicioVigencia ,@FinVigencia)
							

 End 

GO
