SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarPuebloIndigena
**  DESCRIPCION : Permitir agregar un nuevo pueblo indigena                   
**  VERSION     : 1.0           
**  CREACION    : 31/08/2015
**  AUTOR       : Roger Lara
--
-- Modificación:	<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 255.>
*/
 CREATE PROCEDURE [Catalogo].[PA_AgregarPuebloIndigena]
	@Descripcion		varchar(255),
	@InicioVigencia		datetime2,
	@FinVigencia		datetime2
 As
 Begin

   Insert into Catalogo.PuebloIndigena (   TC_Descripcion 
                                          ,TF_Inicio_Vigencia
										  ,TF_Fin_Vigencia )
                                   Values (@Descripcion
										   ,@InicioVigencia
										   ,@FinVigencia)

 End
GO
