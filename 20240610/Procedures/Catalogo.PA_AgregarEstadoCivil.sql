SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarEstadoCivil 
**  DESCRIPCION : Permitir agregar registro en la tabla de                     
**  VERSION     : 1.0           
**  CREACION    : 14/082015
**  AUTOR       : Gerardo Lopez 
   Modificacion: 14/12/2015  Gerardo Lopez <Generar llave por sequence> 
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoCivil]
 @Descripcion varchar(50),
 @FechaActivacion datetime2,
 @FechaDesactivacion datetime2
 As
 Begin
 
   Insert into Catalogo.EstadoCivil  ( TC_Descripcion 
                                          ,TF_Inicio_Vigencia
										  ,TF_Fin_Vigencia )
                                   Values ( @Descripcion
										   ,@FechaActivacion
										   ,@FechaDesactivacion)
 
 End 

GO
