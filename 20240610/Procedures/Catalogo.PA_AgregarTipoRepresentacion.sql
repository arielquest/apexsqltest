SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Roger Lara
-- Fecha de creación:	<07/09/2015>
-- Descripción :		<Permite agregar un nuevo tipo de representacion> 
-- Modificado por:		<Sigifredo Leitón Luna>
-- Fecha:				<07/01/2016>
-- Descripción :		<Modificación para autogenerar el código de tipo de representación - item 5758> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoRepresentacion]
	@Descripcion	varchar(100),
	@InicioVigencia datetime2,
	@FinVigencia	datetime2=nul
AS  
BEGIN
	Insert Into		Catalogo.TipoRepresentacion
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,	@InicioVigencia,	@FinVigencia
	)
End






GO
