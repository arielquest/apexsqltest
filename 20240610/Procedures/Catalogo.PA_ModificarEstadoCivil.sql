SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarMateria 
**  DESCRIPCION : Permitir modificar registro en tabla estado civil                 
**  VERSION     : 1.0           
**  CREACION    : 17/082015
**  AUTOR       : Gerardo Lopez 
-- Modificado por:			<14/12/2015> <GerardoLopez> 	<Se cambia tipo dato CodEstadoCivil a smallint>
*/
  
 CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoCivil]
 @CodEstadoCivil smallint,
 @Descripcion varchar(50), 
 @FechaDesactivacion datetime2
 As
 Begin
 
 	Update	Catalogo.EstadoCivil 
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FechaDesactivacion
	Where	TN_CodEstadoCivil 				=	@CodEstadoCivil

 End 

GO
