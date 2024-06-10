SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*  OBJETO      : PA_ModificarEstadoDiligencia
**  DESCRIPCION : Permitir actualizar registro en la tabla de estado diligencia                   
**  VERSION     : 1.0           
**  CREACION    : 01/10/2015
**  AUTOR       : Roger  lara 
-- Modificacion:  08/12/2015  Modificar tipo dato @CodEstadoDiligencia a smallint
*/
  
 CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoDiligencia]
 @CodEstadoDiligencia  smallint,
 @Descripcion varchar(100),
 @FinVigencia datetime2=null
 As
 Begin
 
   Update Catalogo.EstadoDiligencia
   set TC_Descripcion=@Descripcion,
		TF_Fin_Vigencia= @FinVigencia
   Where TN_CodEstadoDiligencia=@CodEstadoDiligencia
 End 


GO
