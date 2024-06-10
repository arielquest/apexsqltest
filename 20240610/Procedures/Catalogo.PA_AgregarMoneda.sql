SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarMateria 
**  DESCRIPCION : Permitir agregar registro en la tabla de materias                        
**  CREACION    : 06/08/2015 : Gerardo Lopez 

   Modificacion: 08/12/2015  Gerardo Lopez <Generar llave por sequence> 
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarMoneda] 
 @Descripcion varchar(50),
 @InicioVigencia datetime2,
 @FinVigencia datetime2
 As
 Begin

   Insert into [Catalogo].[Moneda] (TC_Descripcion   ,TF_Inicio_Vigencia   ,TF_Fin_Vigencia )
                           Values (@Descripcion ,@InicioVigencia ,@FinVigencia)
							

 End 

GO
