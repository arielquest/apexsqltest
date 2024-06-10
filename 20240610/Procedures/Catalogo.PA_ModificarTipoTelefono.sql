SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Autor:		<Gerardo Lopez>
-- Fecha Creación: <09/11/2015>
-- Descripcion:	<Modificar datos de un tipo telefono>
-- =============================================

 CREATE PROCEDURE [Catalogo].[PA_ModificarTipoTelefono]
 @CodTipoTelefono smallint, 
 @Descripcion varchar(150),
 @FinVigencia datetime2=null
 As
 Begin
 
   Update Catalogo.TipoTelefono
	set TC_Descripcion=@Descripcion,
		TF_Fin_Vigencia= @FinVigencia
	Where TN_CodTipoTelefono=@CodTipoTelefono


 End 


GO
