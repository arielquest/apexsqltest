SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo  Lopez>
-- Fecha de creación:		<03/05/2016>
-- Descripción :			<Permite modificar los tipos de parentesco> 
-- Modificación:			<10/09/2020> <Xinia Soto V.> <Se cambia el código a entero.>  
-- =================================================================================================================================================


  
 CREATE PROCEDURE [Catalogo].[PA_ModificarParentesco]
 @Codigo smallint,
 @Descripcion varchar(50),
 @Nivel smallint,
 @TipoParentesco  char(1),
 @FinVigencia datetime2=null
 As
 Begin
 
   Update Catalogo.Parentesco
	set   TC_Descripcion=@Descripcion,
	      TN_Nivel = @Nivel ,
		  TC_TipoParentesco = @TipoParentesco ,
		  TF_Fin_Vigencia= @FinVigencia
	Where TC_CodParentesco=@Codigo
 End 


GO
