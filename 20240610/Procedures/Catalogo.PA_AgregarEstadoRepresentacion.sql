SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<05/02/2019>
-- Descripción :			<Permitir agregar registro en la tabla EstadoRepresentacion > 
-- =================================================================================================================================================

  
 CREATE  PROCEDURE [Catalogo].[PA_AgregarEstadoRepresentacion]
 @Descripcion			varchar(150),
 @Circulante			char(1),
 @CirculantePasivo		char(1),	
 @FechaActivacion		datetime2,
 @FechaDesactivacion	datetime2
 As
 Begin
 
	Insert into [Catalogo].[EstadoRepresentacion]
	(
		TC_Descripcion,		TC_Circulante,		TC_Pasivo,			TF_Inicio_Vigencia,
		TF_Fin_Vigencia 
	)
	Values 
	(
		@Descripcion,		@Circulante,		@CirculantePasivo,	@FechaActivacion,
		@FechaDesactivacion
	) 
 End 



GO
