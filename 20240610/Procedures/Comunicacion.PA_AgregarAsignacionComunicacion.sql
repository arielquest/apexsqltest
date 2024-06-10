SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<20/04/2017>
-- Descripción:				<Inserta registros en la tabla AsignacionComunicacion> 
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarAsignacionComunicacion] 
   @CodAsignacion Uniqueidentifier,
   @CodComunicacion Uniqueidentifier,
   @CodPuestoTrabajoAsignado Varchar(14),
   @UsuarioAsigna Varchar(30),
   @FechaAsignacion Datetime2

AS
BEGIN

 INSERT INTO  [Comunicacion].[AsignacionComunicacion] 
(
		[TU_CodAsignacion],		[TU_CodComunicacion],	[TC_CodPuestoTrabajoAsignado],	[TC_UsuarioAsigna],
		[TF_FechaAsignacion]
)
 Values 
 (
		@CodAsignacion,			@CodComunicacion,		@CodPuestoTrabajoAsignado,		@UsuarioAsigna,
		@FechaAsignacion	
 )
END
GO
