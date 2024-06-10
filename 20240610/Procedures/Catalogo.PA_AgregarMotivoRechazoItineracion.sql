SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<03/07/2019>
-- Descripción :			<Permitir agregar un nuevo Motivo de Rechazo de Itineración> 
-- =================================================================================================================================================
  
 CREATE  PROCEDURE [Catalogo].[PA_AgregarMotivoRechazoItineracion]
 @Descripcion			varchar(255),
 @InicioVigencia		datetime2,
 @FinVigencia			datetime2
 AS
 BEGIN
 
	Insert into [Catalogo].[MotivoRechazoItineracion]
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia 
	)
	Values 
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	) 
 End 

GO
