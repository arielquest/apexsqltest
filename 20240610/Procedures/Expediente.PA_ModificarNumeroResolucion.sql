SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Jonathan Aguilar Navarro >
-- Fecha Creación:	<22/08/2018>
-- Descripcion:		<Modifica un registro de numero de resolucion en el libro de sentencias, asignando la resolucion y cambiando el estado='A'>
-- =================================================================================================================================================
-- Modificació		<Jonathan Aguilar Navarro><24/03/2021><Se modifica por cambio de la migración de datos del Sistema de Gestión>
-- =================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarNumeroResolucion] 
	@Codigo				uniqueidentifier,
	@NumeroResolucion	bigint,
	@CodResolucion		uniqueidentifier,
	@Estado				varchar(1),
	@UsuarioConfirma	uniqueidentifier,
	@Motivo				varchar(150)	
AS
BEGIN

DECLARE 

@L_Codigo				uniqueidentifier	= @Codigo				,
@L_NumeroResolucion		bigint				= @NumeroResolucion		,
@L_CodResolucion		uniqueidentifier	= @CodResolucion		,
@L_Estado				varchar(1)			= @Estado				,
@L_UsuarioConfirma		uniqueidentifier	= @UsuarioConfirma		,
@L_Motivo				varchar(150)		= @Motivo				
 
UPDATE [Expediente].[LibroSentencia]
      SET        
			TU_CodResolucion		=	@L_CodResolucion,
			TC_Estado				=	@L_Estado,
			TC_JustificacionNoUso	=	@L_Motivo,
			TU_UsuarioConfirma		=	@L_UsuarioConfirma

      WHERE TU_CodLibroSentencia	=	@L_Codigo

 
END
GO
