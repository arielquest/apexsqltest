SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*  OBJETO      : PA_AgregarLugarAtencion. 
**  DESCRIPCION : Permitir agregar registro en la tabla de LugarAtencion.                   
**  VERSION     : 1.0           
**  CREACION    : 17/08/2015
**  AUTOR       : Johan Acosta. 
**  Modificacion: 15/12/2015  Pablo Alvarez <Generar llave por sequence> 
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarLugarAtencion]
 @Descripcion varchar(255),
 @CodProvincia smallint,
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
   Insert into [Catalogo].[LugarAtencion]  (TC_Descripcion
										  ,TN_CodProvincia
                                          ,TF_Inicio_Vigencia
										  ,TF_Fin_Vigencia )
                                   Values  (@Descripcion
										   ,@CodProvincia
										   ,@FechaActivacion
										   ,@FechaVencimiento)
 
 End 



GO
