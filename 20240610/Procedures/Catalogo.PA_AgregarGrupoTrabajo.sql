SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
--  OBJETO      : <PA_AgregarGrupoTrabajo.>
--  DESCRIPCION : <Permitir agregar registro en la tabla de grupo de trabajo.>               
--  VERSION     : <1.0>
--  CREACION    : <18/08/2015>
--  AUTOR       : <Johan Acosta.>
--  Modificado:	  <Alejandro Villalta, 15-12-2015, Modificar tipo de datos del campo codigo>
--  Modificado:	  <Jonathan Aguilar Navarro, 09/04/2018, Cambiar el campo TC_CodOficina por TC_CodContexto>
-- =========================================================================================
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarGrupoTrabajo]
 @Descripcion varchar(255),
 @CodContexto varchar(4),
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
   Insert into [Catalogo].[GrupoTrabajo]  
   (
		TC_Descripcion,	TC_CodContexto, TF_Inicio_Vigencia, TF_Fin_Vigencia 
   )
	Values 
   (	
		@Descripcion,	@CodContexto,	@FechaActivacion,	@FechaVencimiento
   )
 
 End 





GO
