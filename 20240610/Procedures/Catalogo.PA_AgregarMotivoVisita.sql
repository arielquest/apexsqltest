SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--  OBJETO      : <PA_AgregarMotivoVisita>
--  DESCRIPCION : <Permitir agregar registro en la tabla de MotivoVisita>
--  VERSION     : <1.0>           
--  CREACION    : <17/08/2015>
--  AUTOR       : <Johan Acosta.> 
--  Modificado  : <Alejandro Villalta> <04/01/2016> <Autogenerar codigo de motivo de visita> 
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoVisita]
 @Descripcion varchar(255),
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
	Insert into [Catalogo].[MotivoVisita]  
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia 
	)
	Values 
	(
		@Descripcion,	@FechaActivacion,	@FechaVencimiento
	)
 
 End 



GO
