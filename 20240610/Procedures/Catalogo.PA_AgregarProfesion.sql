SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarProfesion. 
**  DESCRIPCION : Permitir agregar registro en la tabla de profesion.                   
**  VERSION     : 1.0           
**  CREACION    : 17/08/2015
**  AUTOR       : Johan Acosta. 
   Modificacion: 14/12/2015  Gerardo Lopez <Generar llave por sequence> 
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarProfesion]
 @Descripcion varchar(255),
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
   Insert into [Catalogo].[Profesion]  (TC_Descripcion 
                                          ,TF_Inicio_Vigencia
										  ,TF_Fin_Vigencia )
                                   Values (@Descripcion
										   ,@FechaActivacion
										   ,@FechaVencimiento)
 
 End 


GO
