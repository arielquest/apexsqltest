SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO       : PA_AgregarCentroReclusion. 
**  DESCRIPCION  : Permitir agregar registro en la tabla de CentroReclusion.                   
**  VERSION      : 1.0           
**  CREACION     : 02/09/2015
**  AUTOR        : Johan Acosta. 
**  MODIFICACION : 08/12/2015
**  MOFICADOR POR: Pablo Alvarez
**  DESCRIPCION  : Se cambia la llave a sequence

*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarCentroReclusion]
 @Descripcion varchar(255),
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
   Insert into [Catalogo].[CentroReclusion]  (TC_Descripcion 
                                          ,TF_Inicio_Vigencia
										  ,TF_Fin_Vigencia )
                                   Values (@Descripcion
										   ,@FechaActivacion
										   ,@FechaVencimiento)
 
 End 


GO
