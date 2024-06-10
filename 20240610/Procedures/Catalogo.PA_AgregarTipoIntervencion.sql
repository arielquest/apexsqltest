SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta.>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permitir agregar registro en la tabla de tipo de intervención.> 
-- Modificado por:			<Sigifredo Leitón Luna.>
-- Fecha de Modificación:	<04/01/2015>
-- Descripción:				<Se realiza cambio para autogenerar el consecutivo de tipo de intervención.>
-- =================================================================================================================================================

  
 CREATE PROCEDURE [Catalogo].[PA_AgregarTipoIntervencion]
 @Descripcion varchar(255),
 @Intervencion	char(1),	
 @FechaActivacion datetime2,
 @FechaVencimiento datetime2
 As
 Begin
 
	Insert into [Catalogo].[TipoIntervencion]  
	(
		TC_Descripcion, TC_Intervencion, TF_Inicio_Vigencia, TF_Fin_Vigencia 
	)
	Values 
	(
		@Descripcion, @Intervencion, @FechaActivacion, @FechaVencimiento
	) 
 End 


GO
