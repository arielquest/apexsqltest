SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara
-- Fecha de creación:		<07/09/2015>
-- Descripción :			<Permite agregar un nuevo tipo de Profesional> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoProfesional]
	@Descripcion varchar(100),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.TipoProfesional
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End






GO
