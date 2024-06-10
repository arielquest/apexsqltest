SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*  OBJETO      : PA_AgregarTipoDictamen. 
**  DESCRIPCION : Permitir agregar registro en la tabla de TipoDictamen.                   
**  VERSION     : 1.0           
**  CREACION    : 01/10/2015
**  AUTOR       : Johan Acosta. 
** 
** Descripcion	: se agrego generacion automatico de codigo
** Creacion		: 16/12/2015
** Autor		: Roger Lara

*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarTipoDictamen]
 @Descripcion varchar(50),
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
   Insert Into [Catalogo].[TipoDictamen](	TC_Descripcion, 
											TF_Inicio_Vigencia,	TF_Fin_Vigencia	)
								Values	(	@Descripcion,
											@FechaActivacion,	@FechaVencimiento)
 
 End 

GO
