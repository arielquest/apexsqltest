SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
--  OBJETO      : PA_ModificarTipoDiligencia
--  DESCRIPCION : Permitir actualizar registro en la tabla de tipo diligencia                   
--  VERSION     : 1.0           
--  CREACION    : 01/10/2015
--  AUTOR       : Roger  lara 
--  Modificacion <Gerardo Lopez> <09/11/2015> <Agregar estado diligencia>
--	Modificacion <Alejandro Villalta> <14/12/2015> <Modificar el tipo de dato del campo codigo.>
-- =============================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
  
 CREATE PROCEDURE [Catalogo].[PA_ModificarTipoDiligencia]
 @CodTipoDiligencia smallint, 
 @Descripcion varchar(100),
 @FinVigencia datetime2=null
 As
 Begin
 
   Update Catalogo.TipoDiligencia
	Set TC_Descripcion=@Descripcion,
		TF_Fin_Vigencia= @FinVigencia
	Where TN_CodTipoDiligencia=@CodTipoDiligencia

 End 


GO
