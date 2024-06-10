SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<19/02/2019>
-- Descripción :			<Permitir agregar registro en la tabla MotivoFinalizacion> 
-- =================================================================================================================================================
  
 CREATE  PROCEDURE [Catalogo].[PA_AgregarMotivoFinalizacion]
 @Descripcion			varchar(255),
 @FechaActivacion		datetime2,
 @FechaDesactivacion	datetime2
 As
 Begin
 
	Insert into [Catalogo].[MotivoFinalizacion]
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia 
	)
	Values 
	(
		@Descripcion,		@FechaActivacion,		@FechaDesactivacion
	) 
 End 
 

GO
