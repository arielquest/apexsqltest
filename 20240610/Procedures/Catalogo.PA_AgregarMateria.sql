SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarMateria 
**  DESCRIPCION : Permitir agregar registro en la tabla de materias                   
**  VERSION     : 1.0           
**  CREACION    : 06/082015
**  AUTOR       : Gerardo Lopez 
**
**  Modificación: <Andrés Díaz><28/11/2016><Se agrega el campo TB_EjecutaRemate.>
*/
 CREATE PROCEDURE [Catalogo].[PA_AgregarMateria]
	 @CodMateria varchar(5),
	 @Descripcion varchar(50),
	 @EjecutaRemate bit,
	 @InicioVigencia datetime2,
	 @FinVigencia datetime2
 As
 Begin
 
   Insert into [Catalogo].[Materia] (TC_CodMateria
									,TC_Descripcion 
									,TB_EjecutaRemate
                                    ,TF_Inicio_Vigencia
									,TF_Fin_Vigencia )
                            Values (@CodMateria
								    ,@Descripcion
									,@EjecutaRemate
									,@InicioVigencia
									,@FinVigencia);
 
 End 
GO
