SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
--  OBJETO      : <PA_AgregarMateria>
--  DESCRIPCION : <Permitir agregar registro en la tabla de materias.>
--  VERSION     : <1.0>
--  CREACION    : <06/08/2015>
--  AUTOR       : <Gerardo Lopez> 
--	Modificado  : <Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto>
-- Modificado:		<Roger Lara><11/05/2021><Se elimina el campo Asunto>
-- ==========================================================================================
-- Modificado:		<Jonathan Aguilar Navarro><21/02/2019><Se agrega el parametro Asunto para ser insertado en la tabla>
  
 CREATE PROCEDURE [Catalogo].[PA_ModificarClaseAsunto]
 @CodClaseAsunto int,
 @Descripcion varchar(200),
 @FechaVencimiento datetime2=null
 As
 Begin
 
  Update Catalogo.ClaseAsunto Set TC_Descripcion	=	@Descripcion,
								  TF_Fin_Vigencia	=	@FechaVencimiento
  Where TN_CodClaseAsunto=@CodClaseAsunto

 End 


GO
