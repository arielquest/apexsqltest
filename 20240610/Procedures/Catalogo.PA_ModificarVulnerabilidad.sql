SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : Modificar vulnerabilidad
--  DESCRIPCION : Permitir modificar una vulnerabilidad             
--  VERSION     : 1.0           
--  CREACION    : 02/09/2015
--  AUTOR       : Roger Lara
--	Modificado	: <Alejandro Villalta, 10-12-2015, Cambiar tipo de dato del codigo de vulnerabilidad.>
--  Modificación: <Donald Vargas> <02/12/2016> <Se corrige el nombre del campo TC_CodVulnerabilidad a TN_CodVulnerabilidad de acuerdo al tipo de dato.>
*/
  
 CREATE PROCEDURE [Catalogo].[PA_ModificarVulnerabilidad]
 @CodVulnerabilidad smallint,
 @Descripcion varchar(255), 
 @FinVigencia datetime2
 As
 Begin
 
 	Update	Catalogo.Vulnerabilidad
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia
	Where	TN_CodVulnerabilidad 				=	@CodVulnerabilidad

 End
GO
