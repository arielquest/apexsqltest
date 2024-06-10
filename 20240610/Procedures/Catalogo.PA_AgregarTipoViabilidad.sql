SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*  OBJETO      : PA_AgregarTipoViabilidad
**  DESCRIPCION : Permitir agregar registro en la tabla de tipo de viabilidad                  
**  VERSION     : 1.0           
**  CREACION    : 14/08/2015
**  AUTOR       : Roger Lara
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarTipoViabilidad]
 @Descripcion varchar(255),
 @InicioVigencia datetime2,
 @FinVigencia datetime2
 As
 Begin
 
   Insert into Catalogo.TipoViabilidad (TC_Descripcion 
                                          ,TF_Inicio_Vigencia
										  ,TF_Fin_Vigencia )
                                   Values (@Descripcion
										   ,@InicioVigencia
										   ,@FinVigencia)
 
 End 

GO
