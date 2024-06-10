SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*  OBJETO      : PA_ModificarMateria 
**  DESCRIPCION : Permitir actualizar registro en la tabla de materias                   
**  VERSION     : 1.0           
**  CREACION    : 07/082015
**  AUTOR       : Olger Gamboa 
** Modificación : <Andrés Díaz><28/11/2016><Se agrega el campo TB_EjecutaRemate.>
*/
 CREATE PROCEDURE [Catalogo].[PA_ModificarMateria]
	@CodMateria varchar(5),
	@Descripcion varchar(50),
	@EjecutaRemate bit,
	@FinVigencia datetime2=null
 As
 Begin
	Update	Catalogo.Materia
	Set		TC_Descripcion		= @Descripcion,
			TB_EjecutaRemate	= @EjecutaRemate,
			TF_Fin_Vigencia		= @FinVigencia
	Where	TC_CodMateria		= @CodMateria;
 End
GO
