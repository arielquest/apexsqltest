SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarVulnerabilidad
**  DESCRIPCION : Permitir agregar registro en la tabla vulnerabilidad               
**  VERSION     : 1.0           
**  CREACION    : 02/09/2015
**  AUTOR       : Roger Lara 
--  Modificado	: <Alejandro Villalta>, <10-12-2015>, <Cambiar tipo de dato del codigo de vulnerabilidad>
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarVulnerabilidad]
 @Descripcion varchar(255),
 @InicioVigencia datetime2,
 @FinVigencia datetime2
 As
 Begin
 
   Insert into Catalogo.Vulnerabilidad 
	(	
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia 
	)
    Values 
	(
		@Descripcion,	@InicioVigencia,	@FinVigencia
	)
 
 End 

GO
