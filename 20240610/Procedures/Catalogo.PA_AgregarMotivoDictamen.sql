SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarMotivoDictamen. 
**  DESCRIPCION : Permitir agregar registro en la tabla de MotivoDictamen.                   
**  VERSION     : 1.0           
**  CREACION    : 01/10/2015
**  AUTOR       : Johan Acosta. 
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoDictamen]
 @Descripcion varchar(150),
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
   Insert Into [Catalogo].[MotivoDictamen](	TC_Descripcion, 
											TF_Inicio_Vigencia,		TF_Fin_Vigencia	)
								Values	(	@Descripcion,
											@FechaActivacion,		@FechaVencimiento)
 
 End 


GO
